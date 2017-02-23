/*File Xslt01.java
Copyright 2003 R.G.Baldwin

This is a modification of the program named
Dom02.java that was discussed in an earlier
lesson.  The program was modified to use an
identity XSLT transform to format the output XML
file in place of a call to Dom02Writer.  This
results in a much simpler program.

The program was also modified to display the
output XML on the Standard Output Device.

The program was also modified to provide
meaningful output in the event of an error.

This program shows you how to:

1. Create a Document object using JAXP, DOM, and
   an input XML file.
2. Create an identity XSL Transformer object.
3. Use the identity XSL Transformer object to
   display the XML represented by the Document
   object on the Standard Output Device.
3. Use the identity XSL Transformer object to
   write the XML represented by the Document
   object into an output file.

The input XML file name is provided by the user
as the first command-line argument.  The output
XML file name is provided by the user as the
second command-line argument.

The program instantiates a DOM parser object
based on JAXP.  The parser is configured in the
default non-validating configuration.

The program uses the parse() method of the parser
object to parse an XML file specified on the
command line.  The parse method returns an object
of type Document that represents the parsed XML
file.

Then the program gets a TransformerFactory object
and uses that object to get a default identity
Transformer object capable of performing a copy
of the source to the result.

Then the program uses the Document object to get
a DOMSource object that acts as a holder for a
transformation Source tree in the form of a
Document Object Model (DOM) tree.

Then the program gets a StreamResult object that
points to the standard output device.  This
object acts as a holder for a transformation
result.

Then the program uses the Transformer object,
the DOMSource object, and the StreamResult object
to transform the DOM tree to text and display it
on the standard output device.

Then the program gets another StreamResult object
that points to an output file, transforms the
DOM tree to text, and writes it into the output
file.

The program catches a variety of different types
of errors and exceptions and provides meaningful
output in the event of an error or exception.

Tested using SDK 1.4.2 and WinXP with two
differentan XML files.  The XML file named
Xslt01.xml is well formed, and reads as follows:

<?xml version="1.0"?>
<bookOfPoems>
  <poem PoemNumber="1" DumAtr="dum val">
    <line>Roses are red,</line>
    <line>Violets are blue.</line>
    <line>Sugar is sweet,</line>
    <line>and so are you.</line>
  </poem>
  <?processor ProcInstr="Dummy"?>
  <!--Comment-->
  <poem PoemNumber="2" DumAtr="dum val">
    <line>Roses are pink,</line>
    <line>Dandelions are yellow,</line>
    <line>If you like Java,</line>
    <line>You are a good fellow.</line>
  </poem>
</bookOfPoems>

The XML file named Xslt01bad.xml is not well
formed and reads as follows:

<?xml version="1.0"?>
<bookOfPoems>
  <poem PoemNumber="1" DumAtr="dum val">
    <line>Roses are red,</line>
    <!--Following line missing > -->
    <line>Violets are blue.</line
    <line>Sugar is sweet,</line>
    <line>and so are you.</line>
  </poem>
  <?processor ProcInstr="Dummy"?>
  <!--Comment-->
  <poem PoemNumber="2" DumAtr="dum val">
    <line>Roses are pink,</line>
    <line>Dandelions are yellow,</line>
    <line>If you like Java,</line>
    <line>You are a good fellow.</line>
  </poem>
</bookOfPoems>

This file is purposely missing a right angle
bracket in the closing tag of a line element,
and is used to test for parser errors.

When processing the well formed XML file, the
program produces the following text on the
Standard Output Device:

<?xml version="1.0" encoding="UTF-8"?>
<bookOfPoems>
  <poem PoemNumber="1" DumAtr="dum val">
    <line>Roses are red,</line>
    <line>Violets are blue.</line>
    <line>Sugar is sweet,</line>
    <line>and so are you.</line>
  </poem>
  <?processor ProcInstr="Dummy"?>
  <!--Comment-->
  <poem PoemNumber="2" DumAtr="dum val">
    <line>Roses are pink,</line>
    <line>Dandelions are yellow,</line>
    <line>If you like Java,</line>
    <line>You are a good fellow.</line>
  </poem>
</bookOfPoems>

When processing the well formed XML file, the
program produces an output XML file that reads
as follows:

<?xml version="1.0" encoding="UTF-8"?>
<bookOfPoems>
  <poem PoemNumber="1" DumAtr="dum val">
    <line>Roses are red,</line>
    <line>Violets are blue.</line>
    <line>Sugar is sweet,</line>
    <line>and so are you.</line>
  </poem>
  <?processor ProcInstr="Dummy"?>
  <!--Comment-->
  <poem PoemNumber="2" DumAtr="dum val">
    <line>Roses are pink,</line>
    <line>Dandelions are yellow,</line>
    <line>If you like Java,</line>
    <line>You are a good fellow.</line>
  </poem>
</bookOfPoems>

When processing the bad XML file, the program
aborts with the following error message on the
standard error device:

SAXParseException
Public ID: null
System ID: file:C:/jnk/Xslt01bad.xml
Line: 7
Column:-1
Next character must be ">" terminating
element "line".

Note that I manually inserted line breaks into
the error message above to force it to fit into
this narrow publication format.

-------------------------------------------------

Changed class name. Xslt01 -> XslTransformer
Added ability to use custom stylesheet.
If only 2 arguments are given, output is
to screen. 
  / Miika Nurminen, 12.12.2003.


************************************************/

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.DocumentBuilder;
import org.w3c.dom.Document;

import
     javax.xml.parsers.FactoryConfigurationError;
import
  javax.xml.parsers.ParserConfigurationException;

import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerException;
import javax.xml.transform.
               TransformerConfigurationException;
import javax.xml.transform.stream.StreamSource;

import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import java.io.File;
import java.io.PrintWriter;
import java.io.FileOutputStream;


public class XslTransformer {

  public static void main(String argv[]){
    if (argv.length < 2){
      System.err.println(
        "usage: java Xslt01 fileIn stylesheet fileOut");
      System.exit(0);
    }//end if

    try{
      //Get a factory object for DocumentBuilder
      // objects with default configuration.
      DocumentBuilderFactory docBuildFactory =
            DocumentBuilderFactory.newInstance();

      //Get a DocumentBuilder (parser) object
      DocumentBuilder parser =
            docBuildFactory.newDocumentBuilder();

      //Parse the XML input file to create a
      // UpFile object that represents the
      // input XML file.
      Document document = parser.parse(
                              new File(argv[0]));

      //Get a TransformerFactory object
      TransformerFactory xformFactory =
                TransformerFactory.newInstance();
      //Get an XSL Transformer object
      Transformer transformer =
                   xformFactory.newTransformer(new StreamSource(argv[1]));
      //Get a DOMSource object that represents
      // the UpFile object
      DOMSource source = new DOMSource(document);

      //Get a StreamResult object that points to
      // the screen.  Then transform the DOM
      // sending XML to the screen.

      if (argv.length==2) { 
        StreamResult scrResult =
                    new StreamResult(System.out);
        transformer.transform(source, scrResult);
      }
    
      //Get an output stream for the output XML
      // file.
      if (argv.length>2) {
        PrintWriter outStream = new PrintWriter(
                  new FileOutputStream(argv[2]));

        //Get a StreamResult object that points to
        // the output file.  Then transform the DOM
        // sending XML to to the file
        StreamResult fileResult =
                     new StreamResult(outStream);
        transformer.transform(source, fileResult);
      }
    }//end try block


    catch(SAXParseException saxEx){
      System.err.println("\nSAXParseException");
      System.err.println("Public ID: " +
                            saxEx.getPublicId());
      System.err.println("System ID: " +
                            saxEx.getSystemId());
      System.err.println("Line: " +
                          saxEx.getLineNumber());
      System.err.println("Column:" +
                        saxEx.getColumnNumber());
      System.err.println(saxEx.getMessage());

      Exception ex = saxEx;
      if(saxEx.getException() != null){
        ex = saxEx.getException();
        System.err.println(ex.getMessage());}
    }//end catch

    catch(SAXException saxEx){
      //This catch block may not be reachable.
      System.err.println("\nParser Error");
      System.err.println(saxEx.getMessage());

      Exception ex = saxEx;
      if(saxEx.getException() != null){
        ex = saxEx.getException();
        System.err.println(ex.getMessage());}
    }//end catch

    catch(ParserConfigurationException parConEx){
      System.err.println(
                        "\nParser Config Error");
      System.err.println(parConEx.getMessage());
    }//end catch

    catch(TransformerConfigurationException
                                     transConEx){
      System.err.println(
                   "\nTransformer Config Error");
      System.err.println(
                        transConEx.getMessage());

      Throwable ex = transConEx;
      if(transConEx.getException() != null){
        ex = transConEx.getException();
        System.err.println(ex.getMessage());}
    }//end catch

    catch(TransformerException transEx){
      System.err.println(
                       "\nTransformation error");
      System.err.println(transEx.getMessage());

      Throwable ex = transEx;
      if(transEx.getException() != null){
        ex = transEx.getException();
        System.err.println(ex.getMessage());}
    }//end catch}

    catch(Exception e){
      e.printStackTrace(System.err);
    }//end catch

  }// end main()
}// class XslTransformer
