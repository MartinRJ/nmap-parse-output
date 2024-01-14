<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:npo="http://xmlns.sven.to/npo">
<npo:comment>
        Grouped output of detected services including service name, product, version, extra information, and CPE (if available), grouped by IP address.
</npo:comment>
<npo:category>extract</npo:category>

    <xsl:output method="text" />
    <xsl:strip-space elements="*" />

    <xsl:template match="/nmaprun">
        <xsl:for-each select="host">
            <xsl:for-each select="ports/port">
                <xsl:if test="state/@state='open'">
                    <xsl:value-of select="../../address[@addrtype='ipv4']/@addr"/>
                    <xsl:text>:</xsl:text>
                    <xsl:value-of select="@portid"/>
                    <xsl:text>:
</xsl:text>
                    <xsl:text>- Service: </xsl:text>
                    <xsl:value-of select="service/@name"/>
                    <xsl:text>
</xsl:text>
                    <xsl:text>- Produkt: </xsl:text>
                    <xsl:value-of select="service/@product"/>
                    <xsl:text>
</xsl:text>
                    <xsl:text>- Version: </xsl:text>
                    <xsl:choose>
                        <xsl:when test="service/@version != ''">
                            <xsl:value-of select="service/@version"/>
                        </xsl:when>
                        <xsl:otherwise>-</xsl:otherwise>
                    </xsl:choose>
                    <xsl:text>
</xsl:text>
                    <xsl:if test="service/@extrainfo != ''">
                        <xsl:text>- Extrainfo: </xsl:text>
                        <xsl:value-of select="service/@extrainfo"/>
                        <xsl:text>
</xsl:text>
                    </xsl:if>
                    <xsl:if test="service/cpe != ''">
                        <xsl:text>- CPE: </xsl:text>
                        <xsl:value-of select="service/cpe"/>
                        <xsl:text>
</xsl:text>
                    </xsl:if>
                    <xsl:text>-----
</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="text()" />
</xsl:stylesheet>
