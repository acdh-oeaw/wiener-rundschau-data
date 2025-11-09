<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="3.0">
    <xsl:output method="xml" indent="yes" suppress-indentation="div"/>
    <xsl:template match="/">
        <xsl:variable name="fname" select="if (.//FNAME) then .//FNAME else replace(tokenize(document-uri(/), '/')[last()], '\.xml$', '')"/>
        <xsl:variable name="fname-parts" select="tokenize($fname, '-')"/>
        <xsl:variable name="has-halbband" select="count($fname-parts) = 4"/>
        
        <xsl:variable name="volume" select="$fname-parts[2]"/>
        <xsl:variable name="halbband" select="if ($has-halbband) then $fname-parts[3] else ''"/>
        <xsl:variable name="issue" select="if ($has-halbband) then tokenize($fname-parts[4], '_')[1] else tokenize($fname-parts[3], '_')[1]"/>
        <xsl:variable name="page" select="tokenize($fname, '_')[2]"/>
        
        <xsl:variable name="year" as="xs:integer">
            <xsl:choose>
                <xsl:when test=".//PUBL_YEAR/text() castable as xs:integer">
                    <xsl:value-of select="xs:integer(.//PUBL_YEAR)"/>
                </xsl:when>
                <xsl:otherwise>2000</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="month" as="xs:integer">
            <xsl:choose>
                <xsl:when test=".//PUBL_MONTH/text() castable as xs:integer">
                    <xsl:value-of select="xs:integer(.//PUBL_MONTH)"/>
                </xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="day">
            <xsl:choose>
                <xsl:when test=".//PUBL_DAY/text() castable as xs:integer">
                    <xsl:try select="format-number(xs:integer(.//PUBL_DAY[1]), '00')">
                        <xsl:catch select="'01'"></xsl:catch>
                    </xsl:try>
                </xsl:when>
                <xsl:otherwise>01</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="writtenDate">
            <xsl:value-of select="string-join(.//PUBL_DATE//text(), ' ')"/>
        </xsl:variable>
        
        <xsl:variable name="pubDate">
                <xsl:value-of select="format-number($year, '0000')"/>-<xsl:value-of select="format-number($month, '00')"/>-<xsl:value-of select="$day"/>
        </xsl:variable>
        <TEI xmlns="http://www.tei-c.org/ns/1.0" xml:id="{$fname}">
            <xsl:if test=".//PREV/text()">
                <xsl:attribute name="prev">
                    <xsl:value-of select=".//PREV"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test=".//NEXT/text()">
                <xsl:attribute name="next">
                    <xsl:value-of select=".//NEXT"/>
                </xsl:attribute>
            </xsl:if>
            
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title level="a">
                            <xsl:value-of select=".//DISP"/>
                        </title>
                        <title level="j">Wiener Rundschau</title>
                    </titleStmt>
                    <publicationStmt>
                        <publisher>
                            <orgName ref="https://d-nb.info/gnd/1226158307">Austrian Centre for Digital Humanities and Cultural Heritage</orgName>
                        </publisher>
                        <availability>
                            <licence target="https://creativecommons.org/licenses/by/4.0/deed.de"/>
                        </availability>
                    </publicationStmt>
                    <sourceDesc>
                        <listBibl n="source pulications">
                            <biblStruct type="journal">
                                <analytic>
                                    <title>Wiener Rundschau, <xsl:value-of select=".//DISP/@expl"/></title>
                                </analytic>
                                <monogr>
                                    <title level="j" ref="https://d-nb.info/gnd/4149123-3">Wiener Rundschau</title>
                                    <imprint>
                                        <biblScope unit="volume" n="{$volume}">
                                            <xsl:value-of select=".//DISP/@volume"/>
                                        </biblScope>
                                        <xsl:if test="$halbband != ''">
                                            <biblScope unit="halbband" n="{$halbband}">
                                                <xsl:choose>
                                                    <xsl:when test=".//DISP/@half">
                                                        <xsl:value-of select=".//DISP/@half"/>
                                                    </xsl:when>
                                                </xsl:choose>
                                            </biblScope>
                                        </xsl:if>
                                        <biblScope unit="issue" n="{$issue}">
                                            <xsl:choose>
                                                <xsl:when test=".//DISP/@issue">
                                                    <xsl:value-of select=".//DISP/@issue"/>
                                                </xsl:when>
                                            </xsl:choose>
                                        </biblScope>
                                        <biblScope unit="page" n="{$page}">
                                            <xsl:value-of select=".//DISP/@page"/>
                                        </biblScope>
                                        <pubPlace ref="https://sws.geonames.org/2761369/">Wien</pubPlace>
                                        <publisher ref="https://d-nb.info/gnd/119098067">Christomanos, Constantin</publisher>
                                        <publisher ref="https://d-nb.info/gnd/1046354299">Rappaport, Felix</publisher>
                                        <publisher ref="https://d-nb.info/gnd/140620923">Schönaich, Gustav</publisher>
                                        <publisher ref="https://d-nb.info/gnd/129223050">Strauss, Rudolf</publisher>
                                        <date when-iso="{$pubDate}"><xsl:value-of select="$writtenDate"/></date>
                                    </imprint>
                                </monogr>
                            </biblStruct>
                            <xsl:for-each select=".//TEXT_START">
                                <bibl n="current text">
                                    <author><xsl:value-of select="./@author"/></author>
                                    <title n="{@shortDisp}"><xsl:value-of select="./@title"/></title>
                                    <biblScope unit="page"><xsl:value-of select="./@startPage"/>-<xsl:value-of select="./@endPage"/></biblScope>
                                    <idno><xsl:value-of select="./@href"/></idno>
                                </bibl>
                            </xsl:for-each>
                        </listBibl>
                        <xsl:if test=".//PREV_ISSUE or .//NEXT_ISSUE">
                            <listBibl n="Context of the current page and text">
                                <xsl:if test=".//PREV_ISSUE">
                                    <bibl n="previous issue">
                                        <title>
                                            <xsl:value-of select=".//PREV_ISSUE/@disp"/>
                                        </title>
                                        <idno><xsl:value-of select=".//PREV_ISSUE/@absRef"/></idno>
                                    </bibl>
                                </xsl:if>
                                <xsl:if test=".//PREV_VOLUME/@href">
                                    <bibl n="previous volume">
                                        <title>
                                            <xsl:value-of select=".//PREV_VOLUME/@disp"/>
                                        </title>
                                        <idno><xsl:value-of select=".//PREV_VOLUME/@href"/></idno>
                                    </bibl>
                                </xsl:if>
                                <xsl:if test=".//NEXT_ISSUE/@href">
                                    <bibl n="next issue">
                                        <title>
                                            <xsl:value-of select=".//NEXT_ISSUE/@disp"/>
                                        </title>
                                        <idno><xsl:value-of select=".//NEXT_ISSUE/@absRef"/></idno>
                                    </bibl>
                                </xsl:if>
                                <xsl:if test=".//NEXT_VOLUME/@href">
                                    <bibl n="next volume">
                                        <title>
                                            <xsl:value-of select=".//NEXT_VOLUME/@disp"/>
                                        </title>
                                        <idno><xsl:value-of select=".//NEXT_VOLUME/@href"/></idno>
                                    </bibl>
                                </xsl:if>
                                <xsl:for-each select=".//PREV_START[@absRef]">
                                    <bibl n="previous text">
                                        <author><xsl:value-of select="./@author"/></author>
                                        <title n="{@shortDisp}"><xsl:value-of select="./@title"/></title>
                                        <biblScope unit="page"><xsl:value-of select="./@startPage"/>-<xsl:value-of select="./@endPage"/></biblScope>
                                        <idno><xsl:value-of select="./@href"/></idno>
                                    </bibl>
                                </xsl:for-each>
                                <xsl:for-each select=".//NEXT_START[@absRef]">
                                    <bibl n="next text">
                                        <author><xsl:value-of select="./@author"/></author>
                                        <title n="{@shortDisp}"><xsl:value-of select="./@title"/></title>
                                        <biblScope unit="page"><xsl:value-of select="./@startPage"/>-<xsl:value-of select="./@endPage"/></biblScope>
                                        <idno><xsl:value-of select="./@href"/></idno>
                                    </bibl>
                                </xsl:for-each>
                            </listBibl>
                        </xsl:if>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>
                <body>
                    <div type="page">
                        <xsl:apply-templates/>
                    </div>
                </body>
            </text>
        </TEI>
    </xsl:template>
    
    <xsl:template match="TABLE">
        <table>
            <xsl:apply-templates/>
        </table>
    </xsl:template>
    
    <xsl:template match="ROW">
        <row>
            <xsl:apply-templates/>
        </row>
    </xsl:template>
    <xsl:template match="CELL">
        <cell>
            <xsl:apply-templates/>
        </cell>
    </xsl:template>
    
    <xsl:template match="DIV_START">
        <milestone>
            <xsl:if test="./@par">
                <xsl:attribute name="xml:id">
                    <xsl:value-of select="./@parid"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="./@itemCnt">
                <xsl:attribute name="n">
                    <xsl:value-of select="./@itemCnt"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="unit">
                <xsl:choose>
                    <xsl:when test="./@type">
                        <xsl:value-of select="./@type||'-start'"/>
                    </xsl:when>
                    <xsl:when test="./@cat">
                        <xsl:value-of select="./@cat||'-start'"/>
                    </xsl:when>
                    <xsl:otherwise>untyped-start</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </milestone>
    </xsl:template>
    
    <xsl:template match="DIV_END">
        <milestone>
            <xsl:attribute name="unit">
                <xsl:choose>
                    <xsl:when test="./@type">
                        <xsl:value-of select="./@type||'-end'"/>
                    </xsl:when>
                    <xsl:when test="./@cat">
                        <xsl:value-of select="./@cat||'-end'"/>
                    </xsl:when>
                    <xsl:otherwise>untyped-end</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </milestone>
    </xsl:template>
    
    <xsl:template match="IMG">
        <figure>
            <xsl:attribute name="type">
                <xsl:choose>
                    <xsl:when test="./@type">
                        <xsl:value-of select="./@type"/>
                    </xsl:when>
                    <xsl:otherwise>image</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:if test="./@itemCnt">
                <xsl:attribute name="n">
                    <xsl:value-of select="./@itemCnt"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </figure>
    </xsl:template>
    
    <xsl:template match="HR">
        <milestone unit="hr"/>
    </xsl:template>
    
    <xsl:template match="SIGNATURE">
        <ab type="signatur">
            <xsl:if test="./@parid">
                <xsl:attribute name="xml:id"><xsl:value-of select="./@parid"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </ab>
    </xsl:template>
    
    <xsl:template match="AUCTOR">
        <rs type="person" key="{@globID}"><xsl:apply-templates/></rs>
    </xsl:template>
    
    <xsl:template match="NAME">
        <rs type="person" key="{@globID}"><xsl:apply-templates/></rs>
    </xsl:template>
    
   
    <xsl:template match="NAV_HEADER"/>
    
    <xsl:template match="P">
        <p>
            <xsl:if test="./@par">
                <xsl:attribute name="xml:id">
                    <xsl:value-of select="./@parid"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test=".[@part='final']">
                <xsl:attribute name="rend" select="'no-intend'"/>
            </xsl:if>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="FN">
        <note type="footnote">
            <xsl:apply-templates/>
        </note>
    </xsl:template>
    
    <xsl:template match="LE">
        <lb />
    </xsl:template>

    <xsl:template match="//LE[following-sibling::*[1][self::HYPH2]]">
        <lb break="no"/>
    </xsl:template>
    
    <xsl:template match="ABBR">
        <abbr xml:id="{./@abbrID}"><xsl:apply-templates/></abbr>
    </xsl:template>
    
    <xsl:template match="I">
        <hi rend="italics"><xsl:apply-templates/></hi>
    </xsl:template>
    
    <xsl:template match="IN">
        <hi rend="initial"><xsl:apply-templates/></hi>
    </xsl:template>
    
    <xsl:template match="B">
        <hi rend="strong"><xsl:apply-templates/></hi>
    </xsl:template>
    
    <xsl:template match="AQ">
        <hi rend="text-spaced"><xsl:apply-templates/></hi>
    </xsl:template>
    
    <xsl:template match="SYMBOL[@type]">
        <milestone unit="{@type}"/>
    </xsl:template>
    
    <xsl:template match="DATE">
        <date><xsl:apply-templates/></date>
    </xsl:template>
    
    <xsl:template match="TITLE">
        <ab>
            <title><xsl:apply-templates/></title>
        </ab>
    </xsl:template>
    
    <xsl:template match="HD">
        <fw type="hd">
            <xsl:apply-templates/>
        </fw>
    </xsl:template>
    
    <xsl:template match="CTEXT">
        <fw type="ctext"><xsl:apply-templates/></fw>
    </xsl:template>
    
    <xsl:template match="HD/node()[@type='pn']">
        <fw type="pn"><xsl:apply-templates/></fw>
    </xsl:template>
    
    <xsl:template match="TABLE/TITLE">
        <head>
            <xsl:apply-templates/>
        </head>
    </xsl:template>
    
    <xsl:template match="LINK[./text()]">
        <ref target="{./@href}">
            <xsl:apply-templates/>
        </ref>
    </xsl:template>
    
    <xsl:template match="LG">
        <lg><xsl:apply-templates/></lg>
    </xsl:template>
    
    <xsl:template match="L">
        <l><xsl:apply-templates/></l>
    </xsl:template>
    
    <xsl:template match="P//LABEL">
        <seg type="label">
            <xsl:if test="./@rend">
                <xsl:attribute name="rend"><xsl:value-of select="./@rend"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </seg>
    </xsl:template>
    <xsl:template match="P//FIELD">
        <seg type="label">
            <xsl:if test="./@rend">
                <xsl:attribute name="rend"><xsl:value-of select="./@rend"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </seg>
    </xsl:template>
    
    <xsl:template match="LABEL">
        <ab type="label">
            <xsl:if test="./@rend">
                <xsl:attribute name="rend"><xsl:value-of select="./@rend"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </ab>
    </xsl:template>
    <xsl:template match="FIELD">
        <ab type="label">
            <xsl:if test="./@rend">
                <xsl:attribute name="rend"><xsl:value-of select="./@rend"/></xsl:attribute>
            </xsl:if><xsl:apply-templates/></ab>
    </xsl:template>
    
    <xsl:template match="PAGE/text()">
        <xsl:if test="normalize-space(.)">
            <ab type="catchall">
                <xsl:value-of select="normalize-space(.)"/>
            </ab>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="PAGE/AUCTOR">
        <ab type="orphaned_author"><rs type="person" key="{@globID}"><xsl:apply-templates/></rs></ab>
    </xsl:template>
    
    <xsl:template match="SPC">
        <hi rend="text-spaced"><xsl:apply-templates/></hi>
    </xsl:template>
    
    <xsl:template match="SEPARATOR">
        <milestone>
            <xsl:choose>
                <xsl:when test="./@type">
                    <xsl:attribute name="unit"><xsl:value-of select="./@type"/></xsl:attribute>
                </xsl:when>
            </xsl:choose>
        </milestone>
    </xsl:template>
    
    <xsl:template match="w">
        <w xml:id="{'w-'||./@wid}" pos="{./@pos}" lemma="{./@lem}"><xsl:apply-templates/></w>
    </xsl:template>

</xsl:stylesheet>