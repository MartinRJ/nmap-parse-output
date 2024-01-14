<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:npo="http://xmlns.sven.to/npo">
<npo:comment>
        Extracts all detected service versions with product and extra information (on open ports).
</npo:comment>
<npo:category>extract</npo:category>

    <xsl:output method="text" />
    <xsl:strip-space elements="*" />

    <xsl:key name="serviceid" match="/nmaprun/host/ports/port/service" use="concat(../../address/@addr, '|', @name, '|', @version)" />
    
    <xsl:template match="/">
        <xsl:for-each select="/nmaprun/host/ports/port/service[generate-id() = generate-id(key('serviceid', concat(../../address/@addr, '|', @name, '|', @version))[1])]">
            <xsl:value-of select="../../../address[@addrtype='ipv4']/@addr"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="@name"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="@version"/>
            <xsl:text> - </xsl:text>
            <xsl:value-of select="@product"/>
            <xsl:if test="@extrainfo != ''">
                <xsl:text> (</xsl:text>
                <xsl:value-of select="@extrainfo"/>
                <xsl:text>)</xsl:text>
            </xsl:if>
            <xsl:text>
</xsl:text>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="text()" />
</xsl:stylesheet>
