<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text"/>
    <xsl:strip-space elements="*"/>

    <!-- Start of the JSON-array -->
    <xsl:template match="/nmaprun">
        <xsl:text>[</xsl:text>
        <xsl:apply-templates select="host"/>
        <xsl:text>]</xsl:text>
    </xsl:template>

    <!-- Template for each host -->
    <xsl:template match="host">
        <xsl:if test="position() != 1">
            <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:text>{"host": "</xsl:text>
        <xsl:value-of select="address[@addrtype='ipv4']/@addr"/>
        <xsl:text>", "services": [</xsl:text>
        <xsl:apply-templates select="ports/port"/>
        <xsl:text>]}</xsl:text>
    </xsl:template>

    <!-- Template for each port -->
<xsl:template match="ports/port">
<xsl:if test="state/@state='open'">
<xsl:if test="position() != 1">
<xsl:text>,</xsl:text>
</xsl:if>
<xsl:text>{"port": </xsl:text>
<xsl:value-of select="@portid"/>
<xsl:text>, "service_name": "</xsl:text>
<xsl:value-of select="service/@name"/>
<xsl:text>", "product": "</xsl:text>
<xsl:value-of select="service/@product"/>
<xsl:text>", "version": "</xsl:text>
<xsl:value-of select="service/@version"/>
<xsl:text>", "cpe": "</xsl:text>
<xsl:value-of select="service/cpe"/>
<xsl:text>"}</xsl:text>
</xsl:if>
</xsl:template>
</xsl:stylesheet>
