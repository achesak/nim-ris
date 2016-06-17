About
=====

nim-ris is a Nim module for parsing Research Information Systems (RIS) citation files.

For the use of the example, assume there is a file named "citation.ris" containing the following text:

    TY  - ELEC
    AU  - Chesak,Adam
    PY  - 2015/09//
    TI  - Nim RIS module documentation
    KW  - Nim
    KW  - RIS
    KW  - module
    UR  - https://github.com/achesak/nim-ris
    N1  - this is a sample citation file
    Y2  - 2015/09/28/
    ER  -

Example:

    # Load the file.
    var citation : RISCitation = parseRIS(open("citation.ris"))
    # Alternatively, in the previous line we could have loaded the file, stored the contents in a variable,
    # and passed that variable to parseRIS(), as it will take either a`File object or a string.
    
    # Print the type of the citation. In this case it is RISType.ELEC, representing a web page.
    echo(citation.referenceType) # outputs "ELEC"
    echo(ciration.referenceType == RISType.ELEC) # outputs true
    
    # Print each author of the work on a separate line.
    for author in citation.authors:
        echo(author)
    # In this example, there is only one author specified. Therefore the only output will be "Chesak,Adam".
    
    # Print the keywords in the citation, separated by spaces.
    var keywords : string = ""
    for kw in citation.keywords:
        keywords &= kw & " "
    echo(keywords) # outputs "Nim RIS module "
    
    # Print some other data from the citation.
    echo("Title: " & citation.title) # outputs "Title: Nim RIS module documentation"
    echo("Year: " & citation.year) # outputs "Year: 2015/09//"
    echo("Access date: " & citation.accessDate) # outputs "Access date: 2015/09/28/"
    echo("Notes: " & citation.notes) # outputs "Notes: this is a sample citation file"

Note that this module mostly forces citation files to have the proper format. The spacing between tags and value
must follow the specification exactly, and the starting tag must be `TY` (reference type) and the ending tag must
be `ER` (end of reference).

However, there are two exceptions to the specification that this module allows. First, blank (space-only) lines are
allowed and will be skipped. Second, unknown tags will not cause the parser to raise an error, but will instead be
added to the `RISCitation.unknownTags` property. This property is a sequence of sequences of strings, where the
first string in the inner sequences is the tag name and the second is the tag value. If your citation uses non-standard
tags you will find them here after the file has been parsed.

License
=======

nim-ris is released under the MIT open source license.
