<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/2000/svg"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <!-- GLOBAL VARIABLES -->
    <xsl:variable name="lines" as="xs:double" select="count(//l)"/>
    <xsl:variable name="earthly" as="xs:integer" select="sum(//earthly/count(l))"/>
    <xsl:variable name="divine" as="xs:integer" select="sum(//divine/count(l))"/>
    <xsl:variable name="maxHeight">
        <xsl:choose>
            <xsl:when test="$earthly > $divine">
                <xsl:value-of select="$earthly"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$divine"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="xScale" as="xs:integer" select="3"/>
    <xsl:variable name="yScale" as="xs:double" select="2"/>
    <xsl:variable name="radius" as="xs:double" select="3"/>

    <xsl:template match="/">
        <svg viewBox="0 -70 {$lines * $xScale + 170} {$maxHeight * $yScale + 125}">
            <g transform="translate(100, {$yScale * $maxHeight})">
                <!-- SCALE -->
                <xsl:for-each select="1 to 10">
                    <!-- LOCAL VARIABLES -->
                    <xsl:variable name="xTenth" as="xs:double" select=". * $lines div 10"/>
                    <xsl:variable name="yTenth" as="xs:double"
                        select=". * ceiling($maxHeight div 10)"/>

                    <!-- TICK MARKS -->
                    <line x1="-10" y1="-{$yTenth * $yScale}" x2="0" y2="-{$yTenth * $yScale}"
                        stroke="black"/>
                    <line x1="{$xTenth * $xScale}" y1="-10" x2="{$xTenth * $xScale}" y2="10"
                        stroke="black"/>

                    <!-- GUIDELINES -->
                    <line x1="0" y1="-{$yTenth * $yScale}" x2="{$lines * $xScale}"
                        y2="-{$yTenth * $yScale}" stroke="lightgrey"/>

                    <!-- LABELS -->
                    <text x="-15" y="-{$yTenth * $yScale}" text-anchor="end"
                        alignment-baseline="central">
                        <xsl:value-of select="$yTenth"/>
                    </text>
                    <text x="{$xTenth * $xScale - 1}" y="3" text-anchor="end"
                        alignment-baseline="hanging">
                        <xsl:value-of select=". * 10"/>
                        <xsl:text>%</xsl:text>
                    </text>
                </xsl:for-each>

                <!-- ZERO -->
                <line x1="-10" y1="0" x2="0" y2="0" stroke="black"/>
                <text x="-15" y="0" text-anchor="end" alignment-baseline="central">
                    <xsl:value-of select="0"/>
                </text>

                <!-- DATA -->
                <xsl:for-each select="//l">
                    <!-- LOCAL VARIABLES -->
                    <xsl:variable name="earthlyCnt" as="xs:integer"
                        select="count(preceding::l[parent::earthly])"/>
                    <xsl:variable name="divineCnt" as="xs:integer"
                        select="count(preceding::l[parent::divine])"/>
                    <xsl:variable name="difference" as="xs:integer"
                        select="$earthlyCnt - $divineCnt"/>

                    <!-- DATA POINTS -->
                    <circle r="{$radius}" cx="{position() * $xScale}" cy="-{$divineCnt * $yScale}"
                        fill="#00FDFF"/>
                    <circle r="{$radius}" cx="{position() * $xScale}" cy="-{$earthlyCnt * $yScale}"
                        fill="#FFC300"/>
                    <xsl:if test="$divineCnt eq $earthlyCnt">
                        <circle r="{$radius}" cx="{position() * $xScale}"
                            cy="-{$earthlyCnt * $yScale}" fill="magenta"/>
                    </xsl:if>

                    <!-- LINE LABEL -->
                    <xsl:if test="position() eq last()">
                        <xsl:choose>
                            <xsl:when test="$divineCnt eq $earthlyCnt">
                                <text x="{(position() + 2) * $xScale}" y="-{$divineCnt * $yScale + 7}"
                                    text-anchor="start" alignment-baseline="central" fill="#00FDFF">
                                    <xsl:text>divine</xsl:text>
                                </text>
                                <text x="{(position() + 2) * $xScale}" y="-{$earthlyCnt * $yScale - 7}"
                                    text-anchor="start" alignment-baseline="central" fill="#FFC300">
                                    <xsl:text>earthly</xsl:text>
                                </text>
                            </xsl:when>
                            <xsl:otherwise>
                                <text x="{(position() + 2) * $xScale}" y="-{$divineCnt * $yScale}"
                                    text-anchor="start" alignment-baseline="central" fill="#00FDFF">
                                    <xsl:text>divine</xsl:text>
                                </text>
                                <text x="{(position() + 2) * $xScale}" y="-{$earthlyCnt * $yScale}"
                                    text-anchor="start" alignment-baseline="central" fill="#FFC300">
                                    <xsl:text>earthly</xsl:text>
                                </text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:for-each>

                <!-- AXES -->
                <line x1="0" y1="0" x2="{$lines * $xScale}" y2="0" stroke="black"/>
                <line x1="0" y1="0" x2="0" y2="-{$yScale * $maxHeight + 50}" stroke="black"/>

                <!-- AXES LABELS -->
                <text x="-50" y="-{$maxHeight div 2 * $yScale}" text-anchor="middle"
                    font-size="larger" transform="rotate(-90 -50 -{$maxHeight div 2 * $yScale})"
                    >Occurrences</text>
                <text x="{$lines * $xScale div 2}" y="50" text-anchor="middle" font-size="larger"
                    alignment-baseline="baseline">Percentage of Scene</text>

                <!-- TITLE -->
                <text x="{$lines * $xScale div 2}" y="-{$maxHeight * $yScale + 55}"
                    text-anchor="middle" font-size="larger" text-decoration="underline">DIVINE AND EARTHLY TRAITS THROUGHOUT SCENE <xsl:value-of select="/scene/@id"
                    /></text>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>
