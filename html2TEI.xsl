<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.tei-c.org/ns/1.0" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:m="http://www.w3.org/1998/Math/MathML"
    exclude-result-prefixes="tei xs m" version="2.0" 
    xmlns:html="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://www.w3.org/1999/xhtml">
    <xsl:import href="/Users/wsalesky/tei/html/html2tei.xsl"/>
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:variable name="idno">
        <xsl:value-of select="normalize-space(//html:span/html:*[starts-with(.,'Vol')]/text()[1])"/>
    </xsl:variable> 
    <xsl:variable name="filename" select="substring-before(tokenize(document-uri(.),'/')[last()],'.html')"/>
    
    <xsl:template match="/">
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:call-template name="teiHeader"/>
            <xsl:call-template name="teiBody"/>            
        </TEI>
    </xsl:template>
    <xsl:template name="teiHeader">
        <teiHeader xmlns="http://www.tei-c.org/ns/1.0">
            <fileDesc>
                <titleStmt>
                    <xsl:choose>
                        <xsl:when test="//html:p[@class='title1']">
                            <title type="main"><xsl:value-of select="normalize-space(string-join(//html:p[@class='title1']//text(),''))"/></title>
                        </xsl:when>
                        <xsl:otherwise>
                            <title type="main"><xsl:value-of select="html:html/html:head/html:title"/></title>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:for-each select="//html:p[@class='author'][preceding-sibling::html:p[1][@class='title1']]">
                        <author>
                            <name>
                                <xsl:variable name="author" select="normalize-space(.)"/>
                                <xsl:variable name="surname">
                                    <xsl:choose>
                                        <xsl:when test="contains($author,'. ')">
                                            <xsl:value-of select="substring-after($author,'. ')"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="normalize-space(tokenize($author,' ')[last()])"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="forename">
                                    <xsl:choose>
                                        <xsl:when test="contains($author,'. ')">
                                            <xsl:value-of select="normalize-space(substring-before($author,$surname))"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="normalize-space(tokenize($author,' ')[1])"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <forename><xsl:value-of select="$forename"/></forename>
                                <surname><xsl:value-of select="concat(upper-case(substring($surname,1,1)),lower-case(substring($surname,2)))"/></surname>
                            </name>
                            <xsl:if test="following-sibling::html:p[1][@class='address']">
                                <affiliation>
                                    <orgName>
                                        <xsl:choose>
                                            <xsl:when test="contains(following-sibling::html:p[1][@class='address']/descendant::text()[1],'@')">
                                                <xsl:value-of select="normalize-space(following-sibling::html:p[1][@class='address']/descendant::text()[2])"/>        
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="normalize-space(following-sibling::html:p[1][@class='address']/descendant::text()[1])"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </orgName>
                                </affiliation>    
                            </xsl:if>
                        </author>
                    </xsl:for-each>
                    <sponsor>Beth Mardutho: The Syriac Institute</sponsor>
                    <editor role="general">George A. Kiraz</editor>
                    <editor role="associate">James E. Walters</editor>
                    <respStmt>
                        <resp>TEI XML encoding by </resp>
                        <name type="script">html2TEI.xsl</name>
                    </respStmt>
                </titleStmt>
                <editionStmt>
                    <edition n="0.1"/>
                </editionStmt>
                <publicationStmt>
                    <xsl:variable name="pubType">
                        <xsl:variable name="v" select="lower-case(normalize-space(string-join(//html:p[@class='pubType']//text(),'')))"/>
                        <xsl:variable name="camelCase" select="
                            string-join((tokenize($v,'\s+')[1],
                            for $word in tokenize($v,'\s+')[position() > 1]
                            return concat(upper-case(substring($word,1,1)),substring($word,2)))
                            ,'')"></xsl:variable>
                        <xsl:choose>
                            <xsl:when test="not(empty($v))">
                                <xsl:value-of select="$camelCase"/>
                            </xsl:when>
                            <xsl:otherwise>article</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <publisher>Beth Mardutho: The Syriac Institute</publisher>
                    <date><xsl:value-of select="normalize-space(//html:span/html:b[starts-with(.,'Vol')]/following-sibling::text())"/></date>
                    <idno><xsl:value-of select="normalize-space($idno)"/></idno>
                    <availability>
                        <licence target="https://creativecommons.org/licenses/by/4.0/">
                            <p>For this publication, a Creative Commons Attribution 4.0 International
                                license has been granted by the author(s), who retain full
                                copyright.</p>
                        </licence>
                    </availability>
                    <idno type="URI">https://hugoye.bethmardutho.org/<xsl:value-of select="concat($pubType,'/',lower-case($filename))"/></idno>
<!--                    <idno type="URI">https://hugoye.org/<xsl:value-of select="$pubType"/>/<xsl:value-of select="replace($idno,'\s|\.|,','')"/></idno>-->
                </publicationStmt>
                <sourceDesc>
                    <biblStruct>
                        <analytic>
                            <xsl:for-each select="//html:p[@class='author'][preceding-sibling::html:p[1][@class='title1']]">
                                <author><xsl:value-of select="normalize-space(.)"/></author>
                            </xsl:for-each>
                            <title level="a"><xsl:value-of select="normalize-space(string-join(//html:p[@class='title1']//text(),''))"/></title>
                            <!--<idno type="URI">http://syriaca.org/bibl/####</idno>  Need to think about how to do this -->
                        </analytic>
                        <monogr>
                            <title level="j">Hugoye: Journal of Syriac Studies</title>
                            <imprint>
                                <publisher>Beth Mardutho: The Syriac Institute</publisher>
                                <date><xsl:value-of select="substring-after(normalize-space(//html:span/html:b[starts-with(.,'Vol')]/following-sibling::text()),' ')"></xsl:value-of></date>
                            </imprint>
                            <biblScope type="vol" n="{substring-before(substring-after($idno,'Vol. '),',')}"><xsl:value-of select="substring-before(substring-after($idno,'Vol. '),',')"/></biblScope>
                            <biblScope type="issue" n="{substring-after($idno,'No. ')}"><xsl:value-of select="substring-after($idno,'No. ')"/></biblScope>
<!--                            <biblScope type="pp" from="3" to="20">3-20</biblScope>-->
                        </monogr>
                    </biblStruct>
                </sourceDesc>
            </fileDesc>
            <!-- meta name="keywords" -->
            <encodingDesc>
                <projectDesc>
                    <p>Hugoye: Journal of Syriac Studies is an electronic journal dedicated to the study
                        of the Syriac tradition, published semi-annually (in January and July) by Beth
                        Mardutho: The Syriac Institute. Published since 1998, Hugoye seeks to offer the
                        best scholarship available in the field of Syriac studies.</p>
                </projectDesc>
            </encodingDesc>
            <profileDesc>
                <langUsage>
                    <language ident="en"/>
                    <!-- If the article is written in another language, declare that here by replacing "en" (English) with the ISO language code for the language in question -->
                </langUsage>
                <textClass>
                    <xsl:if test="//html:meta[@name='keywords']">
                        <keywords xml:lang="en">
                            <xsl:for-each select="tokenize(//html:meta[@name='keywords']/@content,',')">
                                <term><xsl:value-of select="normalize-space(.)"/></term>
                            </xsl:for-each>
                        </keywords>    
                    </xsl:if>
                </textClass>
            </profileDesc>
            <revisionDesc status="uncorrectedTransformation">
                <change when="{current-date()}">File created by XSLT transformation of original HTML encoded article.</change>
            </revisionDesc>
        </teiHeader>
    </xsl:template>
    <xsl:template name="teiBody">
        <text xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:if test="//html:p[@class='Abstract'][. != ''] | //html:p[@class='Acknowledgements'][. != '']">
                <front>
                    <xsl:for-each select="//html:p[@class='Abstract']">    
                        <div type="abstract">
                            <p><xsl:apply-templates/></p>
                        </div>
                    </xsl:for-each>
                    <xsl:for-each select="//html:p[@class='Acknowledgements']">    
                        <div type="acknowledgements">
                          <p><xsl:apply-templates/></p>
                        </div>
                    </xsl:for-each>
                </front>
            </xsl:if>
            <body>
                <xsl:for-each select="//html:body/html:div[@class='center']">    
                    <xsl:apply-templates/>    
                </xsl:for-each>                    
            </body>
        </text>
    </xsl:template>
    <xsl:template match="html:h1|html:h2|html:h3|html:h4|html:h5|html:h6|html:h7">
        <xsl:choose>
            <xsl:when test=". = 'Abstract' or . = 'Acknowledgements' or . = 'Contents'"/>
            <xsl:otherwise>
                <head><xsl:attribute name="xml:id" select="concat($filename,count(preceding::html:h1 | 
                    preceding::html:h2 | preceding::html:h3|preceding::html:h4|preceding::html:h5|preceding::html:h6|preceding::html:h7) +1)"/>
                <xsl:apply-templates/>
                </head>
                <!--
                <xsl:variable name="header" select="."/>
                <div><xsl:attribute name="xml:id" select="concat($filename,count(preceding::html:h1 | 
                    preceding::html:h2 | preceding::html:h3|preceding::html:h4|preceding::html:h5|preceding::html:h6|preceding::html:h7) +1)"/>
                    <head>
                        <xsl:apply-templates/>
                    </head>
                    <xsl:for-each select="following-sibling::*[preceding-sibling::html:h1[1] = $header] | 
                        following-sibling::*[preceding-sibling::html:h2[1] = $header] |
                        following-sibling::*[preceding-sibling::html:h3[1] = $header] |
                        following-sibling::*[preceding-sibling::html:h4[1] = $header]
                        ">
                        <xsl:apply-templates select="."/>
                    </xsl:for-each>
                </div>
                -->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="html:p">
        <xsl:choose>
            <xsl:when test="@class='pubType' or @class='title1' 
                or @class='author' or @class='address' 
                or @class='Acknowledgements'
                or @class='Abstract'"/>
            <xsl:otherwise><p><xsl:apply-templates select="*|text()"/></p></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="a">
        <xsl:choose>
            <xsl:when test="@href">
                <xsl:choose>
                    <xsl:when test="starts-with(@href,'JavaScript')"/>
                    <xsl:otherwise>
                        <ref target="{@href}">
                            <xsl:apply-templates/>
                        </ref>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="@name">
                <anchor>
                    <xsl:attribute name="corresp" select="@name"/>
                </anchor>
                <xsl:apply-templates/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="html:div">
        <xsl:choose>
            <xsl:when test="@class='tit'"/>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="text() and not(*)">
                        <p>
                            <xsl:apply-templates/>
                        </p>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="ul">
        <xsl:choose>
            <xsl:when test="preceding-sibling::*[1] = 'Contents' or preceding-sibling::*[1] = 'Table of Contents'"/>
            <xsl:otherwise>
                <list type="unordered">
                    <xsl:apply-templates/>
                </list>                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="ol">
        <xsl:choose>
            <xsl:when test="preceding-sibling::*[1] = 'Contents' or preceding-sibling::*[1] = 'Table of Contents'"/>
            <xsl:otherwise>
                <list type="ordered">
                    <xsl:apply-templates/>
                </list>          
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>