# Nim module for parsing RIS bibliography files.

# Written by Adam Chesak.
# Released under the MIT open source license.


## ris is a Nim module for parsing Research Information Systems citation files.
##
## For the use of the example, assume there is a file named "citation.ris" containing the following text:
##
##  ::
##    TY  - ELEC
##    AU  - Chesak,Adam
##    PY  - 2015/09//
##    TI  - Nim RIS module documentation
##    KW  - Nim
##    KW  - RIS
##    KW  - module
##    UR  - https://github.com/achesak/nim-ris
##    N1  - this is a sample citation file
##    Y2  - 2015/09/28/
##    ER  -
##
## Example:
##
## .. code-block:: nimrod
##    
##    # Load the file.
##    var citation : RISCitation = parseRIS(open("citation.ris"))
##    # Alternatively, in the previous line we could have loaded the file, stored the contents in a variable,
##    # and passed that variable to parseRIS(), as it will take either a`File object or a string.
##    
##    # Print the type of the citation. In this case it is RISType.ELEC, representing a web page.
##    echo(citation.referenceType) # outputs "ELEC"
##    echo(ciration.referenceType == RISType.ELEC) # outputs true
##    
##    # Print each author of the work on a separate line.
##    for author in citation.authors:
##        echo(author)
##    # In this example, there is only one author specified. Therefore the only output will be "Chesak,Adam".
##    
##    # Print the keywords in the citation, separated by spaces.
##    var keywords : string = ""
##    for kw in citation.keywords:
##        keywords &= kw & " "
##    echo(keywords) # outputs "Nim RIS module "
##    
##    # Print some other data from the citation.
##    echo("Title: " & citation.title) # outputs "Title: Nim RIS module documentation"
##    echo("Year: " & citation.year) # outputs "Year: 2015/09//"
##    echo("Access date: " & citation.accessDate) # outputs "Access date: 2015/09/28/"
##    echo("Notes: " & citation.notes) # outputs "Notes: this is a sample citation file"
##
## Note that this module mostly forces citation files to have the proper format. The spacing between tags and value
## must follow the specification exactly, and the starting tag must be "TY" (reference type) and the ending tag must
## be "ER" (end of reference).
##
## However, there are two exceptions to the specification that this module allows. First, blank (space-only) lines are
## allowed and will be skipped. Second, unknown tags will not cause the parser to raise an error, but will instead be
## added to the ``RISCitation.unknownTags`` property. This property is a sequence of sequences of strings, where the
## first string in the inner sequences is the tag name and the second is the tag value. If your citation uses non-standard
## tags you will find them here after the file has been parsed.

import strutils


type 
    RISCitation* = ref RISCitationInternal
    RISCitationInternal* = object
        referenceType : RISType          # TY
        authors : seq[string]            # AU
        secondaryAuthors : seq[string]   # A2
        tertiaryAuthors : seq[string]    # A3
        subsidiaryAuthors : seq[string]  # A4
        abstract : string                # AB
        authorAddress : string           # AD
        accessionNumber : string         # AN
        custom1 : string                 # C1
        custom2 : string                 # C2
        custom3 : string                 # C3
        custom4 : string                 # C4
        custom5 : string                 # C5
        custom6 : string                 # C6
        custom7 : string                 # C7
        custom8 : string                 # C8
        caption : string                 # CA
        callNumber : string              # CN
        placePublished : string          # CY
        date : string                    # DA
        databaseName : string            # DB
        doi : string                     # DO
        databaseProvider : string        # DP
        endPage : string                 # EP
        edition : string                 # ET
        number : string                  # IS
        alternateTitle : string          # J2
        keywords : seq[string]           # KW
        fileAttachments : string         # L1
        figure : string                  # L4
        language : string                # LA
        label : string                   # LB
        workType : string                # M3
        notes : string                   # N1
        numberOfVolumes : string         # NV
        originalPublication : string     # OP
        publisher : string               # PB
        year : string                    # PY
        reviewedItem : string            # RI
        researchNotes : string           # RN
        reprintEdition : string          # RP
        section : string                 # SE
        isbn : string                    # SN
        startPage : string               # SP
        shortTitle : string              # ST
        primaryTitle : string            # T1
        secondaryTitle : string          # T2
        tertiaryTitle : string           # T3
        translatedAuthor : string        # TA
        title : string                   # TI
        translatedTitle : string         # TT
        url : string                     # UR
        volume : string                  # VL
        accessDate : string              # Y2
        unknownTags : seq[seq[string]]   # Unknown tags. Used instead of failing for non-standard files. 
                                         # In the format [["TAG1", "VALUE1"],["TAG2", "VALUE2"]]
    
    
    RISType* {.pure.} = enum
        ABST,     # Abstract
        ADVS,     # Audiovisual material
        AGGR,     # Aggregated Database
        ANCIENT,  # Ancient Text
        ART,      # Art Work
        BILL,     # Bill
        BLOG,     # Blog
        BOOK,     # Whole book
        CASETYPE, # Case - Note that this is the only constant that differs from the string format name
        CHAP,     # Book chapter
        CHART,    # Chart
        CLSWK,    # Classical Work
        COMP,     # Computer program
        CONF,     # Conference proceeding
        CPAPER,   # Conference paper
        CTLG,     # Catalog
        DATA,     # Data file
        DBASE,    # Online Database
        DICT,     # Dictionary
        EBOOK,    # Electronic Book
        ECHAP,    # Electronic Book Section
        EDBOOK,   # Edited Book
        EJOUR,    # Electronic Article
        ELEC,     # Web Page
        ENCYC,    # Encyclopedia
        EQUA,     # Equation
        FIGURE,   # Figure
        GEN,      # Generic
        GOVDOC,   # Government Document
        GRANT,    # Grant
        HEAR,     # Hearing
        ICOMM,    # Internet Communication
        INPR,     # In Press
        JFULL,    # Journal (full)
        JOUR,     # Journal
        LEGAL,    # Legal Rule or Regulation
        MANSCPT,  # Manuscript
        MAP,      # Map
        MGZN,     # Magazine article
        MPCT,     # Motion picture
        MULTI,    # Online Multimedia
        MUSIC,    # Music score
        NEWS,     # Newspaper
        PAMP,     # Pamphlet
        PAT,      # Patent
        PCOMM,    # Personal communication
        RPRT,     # Report
        SER,      # Serial publication
        SLIDE,    # Slide
        SOUND,    # Sound recording
        STAND,    # Standard
        STAT,     # Statute
        THES,     # Thesis/Dissertation
        UNPB,     # Unpublished work
        VIDEO     # Video recording
    
    
    RISFormatError* = object of Exception


proc getRISType*(typeString : string): RISType = 
    ## Gets the RIS type as a ``RISType`` constant.
    
    case typeString
    of "ABST":
        return RISType.ABST
    of "ADVS":
        return RISType.ADVS
    of "AGGR":
        return RISType.AGGR
    of "ANCIENT":
        return RISType.ANCIENT
    of "ART":
        return RISType.ART
    of "BILL":
        return RISType.BILL
    of "BLOG":
        return RISType.BLOG
    of "BOOK":
        return RISType.BOOK
    of "CASE":
        return RISType.CASETYPE
    of "CHAP":
        return RISType.CHAP
    of "CHART":
        return RISType.CHART
    of "CLSWK":
        return RISType.CLSWK
    of "COMP":
        return RISType.COMP
    of "CONF":
        return RISType.CONF
    of "CPAPER":
        return RISType.CPAPER
    of "CTLG":
        return RISType.CTLG
    of "DATA":
        return RISType.DATA
    of "DBASE":
        return RISType.DBASE
    of "DICT":
        return RISType.DICT
    of "EBOOK":
        return RISType.EBOOK
    of "ECHAP":
        return RISType.ECHAP
    of "EDBOOK":
        return RISType.EDBOOK
    of "EJOUR":
        return RISType.EJOUR
    of "ELEC":
        return RISType.ELEC
    of "ENCYC":
        return RISType.ENCYC
    of "EQUA":
        return RISType.EQUA
    of "FIGURE":
        return RISType.FIGURE
    of "GEN":
        return RISType.GEN
    of "GOVDOC":
        return RISType.GOVDOC
    of "GRANT":
        return RISType.GRANT
    of "HEAR":
        return RISType.HEAR
    of "ICOMM":
        return RISType.ICOMM
    of "INPR":
        return RISType.INPR
    of "JFULL":
        return RISType.JFULL
    of "JOUR":
        return RISType.JOUR
    of "LEGAL":
        return RISType.LEGAL
    of "MANSCPT":
        return RISType.MANSCPT
    of "MAP":
        return RISType.MAP
    of "MGZN":
        return RISType.MGZN
    of "MPCT":
        return RISType.MPCT
    of "MULTI":
        return RISType.MULTI
    of "MUSIC":
        return RISType.MUSIC
    of "NEWS":
        return RISType.NEWS
    of "PAMP":
        return RISType.PAMP
    of "PAT":
        return RISType.PAT
    of "PCOMM":
        return RISType.PCOMM
    of "RPRT":
        return RISType.RPRT
    of "SER":
        return RISType.SER
    of "SLIDE":
        return RISType.SLIDE
    of "SOUND":
        return RISType.SOUND
    of "STAND":
        return RISType.STAND
    of "STAT":
        return RISType.STAT
    of "THES":
        return RISType.THES
    of "UNPB":
        return RISType.UNPB
    of "VIDEO":
        return RISType.VIDEO
    else:
        raise newException(RISFormatError, "getRISType(): unknown type \"" & typeString & "\"")
    


proc parseRIS*(ris : string): RISCitation =
    ## Parses an RIS citation from the provided string.
    
    var linesStr : seq[string] = ris.splitLines()
    var lines : seq[seq[string]] = newSeq[seq[string]](len(linesStr))
    for i in 0..high(linesStr):
        if linesStr[i].strip(leading = true, trailing = true) == "":
            continue
        var line : seq[string] = newSeq[string](2)
        line[0] = linesStr[i][0..1]
        line[1] = linesStr[i][6..high(linesStr[i])]
        lines[i] = line
    
    if lines[0][0] != "TY":
        raise newException(RISFormatError, "parseRIS(): first tag is not TY (type of reference)")
    if lines[high(lines)][0] != "ER":
        raise newException(RISFormatError, "parseRIS(): last tag is not ER (end of reference)")
    
    var citation : RISCitation = RISCitation(authors: @[], secondaryAuthors: @[], tertiaryAuthors: @[], subsidiaryAuthors: @[], keywords: @[], unknownTags: @[])
    for i in lines:
        
        case i[0]
        of "TY":
            citation.referenceType = getRISType(i[1])
        of "AU":
            citation.authors.add(i[1])
        of "A2":
            citation.secondaryAuthors.add(i[1])
        of "A3":
            citation.tertiaryAuthors.add(i[1])
        of "A4":
            citation.subsidiaryAuthors.add(i[1])
        of "AB":
            if isNil(citation.abstract):
                citation.abstract = i[1]
        of "AD":
            if isNil(citation.authorAddress):
                citation.authorAddress = i[1]
        of "AN":
            if isNil(citation.accessionNumber):
                citation.accessionNumber = i[1]
        of "C1":
            if isNil(citation.custom1):
                citation.custom1 = i[1]
        of "C2":
            if isNil(citation.custom2):
                citation.custom2 = i[1]
        of "C3":
            if isNil(citation.custom3):
                citation.custom3 = i[1]
        of "C4":
            if isNil(citation.custom4):
                citation.custom4 = i[1]
        of "C5":
            if isNil(citation.custom5):
                citation.custom5 = i[1]
        of "C6":
            if isNil(citation.custom6):
                citation.custom6 = i[1]
        of "C7":
            if isNil(citation.custom7):
                citation.custom7 = i[1]
        of "C8":
            if isNil(citation.custom8):
                citation.custom8 = i[1]
        of "CA":
            if isNil(citation.caption):
                citation.caption = i[1]
        of "CN":
            if isNil(citation.callNumber):
                citation.callNumber = i[1]
        of "CY":
            if isNil(citation.placePublished):
                citation.placePublished = i[1]
        of "DA":
            if isNil(citation.date):
                citation.date = i[1]
        of "DB":
            if isNil(citation.databaseName):
                citation.databaseName = i[1]
        of "DO":
            if isNil(citation.doi):
                citation.doi = i[1]
        of "DP":
            if isNil(citation.databaseProvider):
                citation.databaseProvider = i[1]
        of "EP":
            if isNil(citation.endPage):
                citation.endPage = i[1]
        of "ET":
            if isNil(citation.edition):
                citation.edition = i[1]
        of "IS":
            if isNil(citation.number):
                citation.number = i[1]
        of "J2":
            if isNil(citation.alternateTitle):
                citation.alternateTitle = i[1]
        of "KW":
            citation.keywords.add(i[1])
        of "L1":
            if isNil(citation.fileAttachments):
                citation.fileAttachments = i[1]
        of "L4":
            if isNil(citation.figure):
                citation.figure = i[1]
        of "LA":
            if isNil(citation.language):
                citation.language = i[1]
        of "LB":
            if isNil(citation.label):
                citation.label = i[1]
        of "M3":
            if isNil(citation.workType):
                citation.workType = i[1]
        of "N1":
            if isNil(citation.notes):
                citation.notes = i[1]
        of "NV":
            if isNil(citation.numberOfVolumes):
                citation.numberOfVolumes = i[1]
        of "OP":
            if isNil(citation.originalPublication):
                citation.originalPublication = i[1]
        of "PB":
            if isNil(citation.publisher):
                citation.publisher = i[1]
        of "PY":
            if isNil(citation.year):
                citation.year = i[1]
        of "RI":
            if isNil(citation.reviewedItem):
                citation.reviewedItem = i[1]
        of "RN":
            if isNil(citation.researchNotes):
                citation.researchNotes = i[1]
        of "RP":
            if isNil(citation.reprintEdition):
                citation.reprintEdition = i[1]
        of "SE":
            if isNil(citation.section):
                citation.section = i[1]
        of "SN":
            if isNil(citation.isbn):
                citation.isbn = i[1]
        of "SP":
            if isNil(citation.startPage):
                citation.startPage = i[1]
        of "ST":
            if isNil(citation.shortTitle):
                citation.shortTitle = i[1]
        of "T1":
            if isNil(citation.primaryTitle):
                citation.primaryTitle = i[1]
        of "T2":
            if isNil(citation.secondaryTitle):
                citation.secondaryTitle = i[1]
        of "T3":
            if isNil(citation.tertiaryTitle):
                citation.tertiaryTitle = i[1]
        of "TA":
            if isNil(citation.translatedAuthor):
                citation.translatedAuthor = i[1]
        of "TI":
            if isNil(citation.title):
                citation.title = i[1]
        of "TT":
            if isNil(citation.translatedTitle):
                citation.translatedTitle = i[1]
        of "UR":
            if isNil(citation.url):
                citation.url = i[1]
        of "VL":
            if isNil(citation.volume):
                citation.volume = i[1]
        of "Y2":
            if isNil(citation.accessDate):
                citation.accessDate = i[1]
        of "ER":
            break
        else:
            citation.unknownTags.add(@[i[0], i[1]])
    
    return citation


proc parseRIS*(ris : File): RISCitation = 
    ## Parses an RIS citation from the provided file.
    
    var fileContents : string = ris.readAll()
    ris.close()
    
    return parseRIS(fileContents)

