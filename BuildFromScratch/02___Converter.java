import javax.swing.*;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.util.Arrays;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.function.Function;
import java.util.function.Supplier;

public class Converter {
    public void convert() throws IOException {
        //Set LAF
        setLAF();

        //Get CSV Dir
        final File csvDir = getCsvDir();
        System.out.println("File: " + csvDir);

        //Establish Output Dir
        final File outputFile = new File(csvDir, "CREATE_RAW_DB.sql");

        //Clobber Check
        FileOutputStream fos;
        PrintWriter file_writer;
        if (outputFile.exists()) {
            final String errMsg = "Error! Output file already exists. Aborting.";
            System.err.println(errMsg);
            showErrorMessage(errMsg);
            return;
        } else {
            //Make Output File
            outputFile.createNewFile();
            fos = new FileOutputStream(outputFile, true);
            file_writer = new PrintWriter(fos);
        }

        //Create Database
        file_writer.println("START TRANSACTION;");
        file_writer.println("-- \n-- Database: `fbi_violent_crime_stats_2005_2019_raw_data`\n-- ");
        file_writer.println("CREATE DATABASE `fbi_violent_crime_stats_2005_2019_raw_data`;");
        file_writer.println("USE `fbi_violent_crime_stats_2005_2019_raw_data`;");
        file_writer.println("\n\n-- ------------------------------------------------\n\n");

        //Get CSV Files
        File[] csvFiles = csvDir.listFiles(file -> file.isFile() && getFilenameChunks(file.getName()).ext.equalsIgnoreCase("csv"));

        //Convert Files
        for (File csvFile : csvFiles) {
            System.out.print(String.format("Processing File '%s'...", csvFile.getName()));

            //Read File
            final List<String> lines = Files.readAllLines(csvFile.toPath());
            final Iterator<String> it = lines.iterator();

            {//Ignore
                //Table Number line
                if (!startsWithIgnoreCase(it.next(), "table")) {
                    throw new IllegalArgumentException("Unrecognized File Structure");
                }

                //Title line 1
                if (!startsWithIgnoreCaseOR(it.next(), "Murder", "Robbery", "Aggravated", "Crime")) {
                    throw new IllegalArgumentException("Unrecognized File Structure");
                }

                //Title line 2
                if (!startsWithIgnoreCaseOR(it.next(), "\"by State", "\"by Volume")) {
                    throw new IllegalArgumentException("Unrecognized File Structure");
                }
            }

            //Table Columns
            final String[] tableColumnNames = parseCsvRow(it.next().trim());

            //Table Data
            final List<String[]> dataRows = new LinkedList<>();

            //loop until first char is number, then end.
            while (it.hasNext()) {
                //Read Next Line Raw
                final String line = it.next().trim();

                //Check for end of data (quoted numbered text; i.e. footnote)
                //Check all nums just in case the footers are out of order.
                if (startsWithIgnoreCaseOR(line, "\"1 ", "\"2 ", "\"3 ", "\"4 ", "\"5 ", "\"6 ", "\"7 ", "\"8 ", "\"9 ")) {
                    //We're into the footnotes
                    break;
                }

                //Parse Data
                final String[] curDataRow = parseCsvRow(line);

                //Save Data Row
                dataRows.add(curDataRow);
            }
            //Check that you got at least 50 rows (all states and optionally DC) -- NVM, in 2005 (at least) Florida didn't report.


            //
            //Create Table
            //
            final String CREATE_TABLE_STATEMENT;
            final String TABLE_NAME;
            final String[] COLUMN_NAMES;
            {
                Iterator<String> columnNamesIter = Arrays.stream(tableColumnNames).iterator();
                LinkedList<String> columnNames_tmp = new LinkedList<>();

                //Table Name
                TABLE_NAME = getFilenameChunks(csvFile.getName()).name
                        .toUpperCase()
                        .replaceAll("-", "_");
                String createTable_tmp = "CREATE TABLE `" + TABLE_NAME + "` (\n";

                //Primary Key
                createTable_tmp += "\t`ID` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,\n";
                //Don't add ID to column names list. We leave it out to auto-populate.

                //State Name Column
                String stateColumnName = escapeSqlColumnName(columnNamesIter.next());
                createTable_tmp += "\t`" + stateColumnName + "` VARCHAR(50) NOT NULL";
                columnNames_tmp.add(stateColumnName);

                //Data Columns
                while(columnNamesIter.hasNext()) {
                    final String dataColumnName = escapeSqlColumnName(columnNamesIter.next());
                    columnNames_tmp.add(dataColumnName);

                    createTable_tmp += ",\n\t`" + dataColumnName + "` ";

                    //Data Type
                    if (dataColumnName.toLowerCase().endsWith("_rate".toLowerCase())) {
                        createTable_tmp += "DOUBLE";
                    } else {
                        createTable_tmp += "INTEGER";
                    }
                }

                //Close Create Table Statement
                createTable_tmp += "\n);";

                //Save Final
                COLUMN_NAMES = columnNames_tmp.toArray(new String[]{});
                CREATE_TABLE_STATEMENT = createTable_tmp;
            }

            //
            //Insert Data
            //
            final String INSERT_STATEMENT;
            {
                String insertStatement_tmp = "INSERT INTO `" + TABLE_NAME + "` (";

                {//Enumerate Columns
                    final Delimiterator delim = new Delimiterator(", ");
                    for (String columnName : COLUMN_NAMES) {
                        //Separator
                        insertStatement_tmp += delim.getDelimiter();

                        //Column Name
                        insertStatement_tmp += "`" + columnName + "`";
                    }
                }

                //Values
                insertStatement_tmp += ") VALUES\n";

                {//Enumerate Data
                    final Delimiterator outerDelim = new Delimiterator(",\n");
                    final Delimiterator innerDelim = new Delimiterator(", ");
                    final FirstElseFunction<String, String> stateNameQuoteWrapper = new FirstElseFunction<>(
                            //First Time
                            (s) -> "'" + s + "'",

                            //Else
                            (s) -> s
                    );
                    for (String[] row : dataRows) {
                        //Line Separator
                        insertStatement_tmp += outerDelim.getDelimiter();

                        //Tab In, and Open Parenthesis
                        insertStatement_tmp += "\t(";

                        //Row Data
                        for (String cell : row) {
                            //Separator
                            insertStatement_tmp += innerDelim.getDelimiter();

                            //
                            //Column Data
                            //

                            //Remove commas from number strings, otherwise MySQL will truncate it when trying to convert
                            //it to a number, for some stupid reason.
                            cell = cell.replaceAll(",", "");

                            //Null Check
                            if (cell.isBlank()) {
                                insertStatement_tmp += "null";
                            } else {
                                insertStatement_tmp += stateNameQuoteWrapper.doFirstThenElse(cell);
                            }
                        }

                        //Close Parenthesis
                        insertStatement_tmp += ")";

                        //Reset row delimiter for next row
                        stateNameQuoteWrapper.reset();
                        innerDelim.reset();
                    }
                }

                //Close Values Segment
                insertStatement_tmp += ";";

                //Save Final
                INSERT_STATEMENT = insertStatement_tmp;
            }

            //
            // Append SQL to File
            //
            file_writer.println(String.format("-- \n-- Create Table `%s`\n-- ", TABLE_NAME));
            file_writer.println(CREATE_TABLE_STATEMENT);
            file_writer.println(String.format("\n\n-- \n-- Insert Values into `%s`\n-- ", TABLE_NAME));
            file_writer.println(INSERT_STATEMENT);
            file_writer.println("\n\n-- ------------------------------------------------\n\n");

            //Log File Complete
            System.out.println("Done!");
        }

        //Commit Transaction
        file_writer.println("\n\n-- ------------------------------------------------\n\n");
        file_writer.println("COMMIT;\n\n");

        //Flush Streams
        file_writer.flush();
        fos.flush();

        //Close File
        fos.close();
        file_writer.close();
    }


    public static class FirstElseFunction<T, R> {
        private boolean isFirst;
        private Function<T, R> firstTimeFunc;
        private Function<T, R> elseFunc;

        public FirstElseFunction(Function<T, R> firstTimeFunc, Function<T, R> elseFunc) {
            this.isFirst = true;
            this.firstTimeFunc = firstTimeFunc;
            this.elseFunc = elseFunc;
        }

        public R doFirstThenElse(T param) {
            if (isFirst) {
                isFirst = false;
                return firstTimeFunc.apply(param);
            } else {
                return elseFunc.apply(param);
            }
        }

        public void reset() {
            isFirst = true;
        }
    }

    public static class FirstElseSupplier<R> {
        private FirstElseFunction<Object, R> exec;

        public FirstElseSupplier(Supplier<R> firstTimeFunc, Supplier<R> elseFunc) {
            this.exec = new FirstElseFunction(
                    (x) -> firstTimeFunc.get(),
                    (x) -> elseFunc.get()
            );
        }

        public R doFirstThenElse() {
            return exec.doFirstThenElse(null);
        }

        public void reset() {
            exec.reset();
        }
    }

    public static class Delimiterator {
        private FirstElseSupplier<String> exec;

        public Delimiterator(final String delimiter) {
            this.exec = new FirstElseSupplier<>(
                    () -> "",
                    () -> delimiter
            );
        }

        public String getDelimiter() {
            return exec.doFirstThenElse();
        }

        public void reset() {
            exec.reset();
        }
    }

    public static String escapeSqlColumnName(final String str) {
        return str
                .trim()
                .toUpperCase()
                .replaceAll(" ", "_")
                .replaceAll("-", "_")
                .replaceAll(",", "")
                .replaceAll("\\.", "")
                .replaceAll("\\(", "")
                .replaceAll("\\)", "");
    }

    public static String[] parseCsvRow(final String line) {
        LinkedList<String> cells = new LinkedList<>();
        String tmp = "";

        //Parse
        boolean inQuotedText = false;
        for (char c : line.toCharArray()) {
            if (inQuotedText) {
                if (c == '"') {
                    //End Quote
                    inQuotedText = false;
                } else if (c == ',') {
                    //Ignore Comma
                    tmp += c;
                } else {
                    //All Other Chars
                    tmp += c;
                }
            } else {
                if (c == '"') {
                    //Start Quote
                    inQuotedText = true;
                } else if (c == ',') {
                    //Non-Quoted Comma
                    //
                    //Cell Delimiter
                    cells.addLast(tmp);
                    tmp = "";
                } else {
                    //All Other Chars
                    tmp += c;
                }
            }
        }

        //Last Cell of Line is not ended by comma
        cells.addLast(tmp);
        tmp = "";

        //Return
        return cells.toArray(new String[]{});
    }

    public static boolean startsWithIgnoreCaseOR(final String target, final String ... testStrs) {
        boolean anyDo = false;
        for (String testStr : testStrs) {
            if (startsWithIgnoreCase(target, testStr)) {
                anyDo = true;
            }
        }
        return anyDo;
    }

    public static boolean startsWithIgnoreCase(final String target, final String testStr) {
        return target.trim().toLowerCase().startsWith(testStr.toLowerCase());
    }

    public static FilenameChunks getFilenameChunks(final String filename) {
        final int index = filename.lastIndexOf('.');
        return new FilenameChunks(
                filename.substring(0, index),
                filename.substring(index + 1)
        );
    }

    public static class FilenameChunks {
        final String name;
        final String ext;

        public FilenameChunks(String name, String ext) {
            this.name = name;
            this.ext = ext;
        }
    }

    public File getCsvDir() {
        //Show Instruction Dialog
        JOptionPane.showMessageDialog(null, "Choose the directory containing the CSV files.");

        //Open Browse Dialog
        JFileChooser browse = new JFileChooser(new File("C:/"));
        browse.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
        final int retVal = browse.showOpenDialog(null);

        //Get Selection
        if (retVal == JFileChooser.APPROVE_OPTION) {
            return browse.getSelectedFile();
        } else {
            return null;
        }
    }

    public void setLAF() {
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        }
        catch (Exception e) {
            showErrorMessage("Error! Unable to set system Look And Feel.\nContinuing with default Java Look And Feel.");
        }
    }

    public static void showErrorMessage(final String errMsg) {
        JOptionPane.showMessageDialog(
                null,
                errMsg,
                "Error!",
                JOptionPane.ERROR_MESSAGE
        );
    }

    public static void main(String[] args) throws IOException {
        new Converter().convert();
    }
}
