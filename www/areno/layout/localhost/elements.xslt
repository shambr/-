<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template name="your-name">
    <h3>Ваше имя:</h3>
    <xsl:choose>
        <xsl:when test="$is_moderator">
            <select name="impersonate_id">
                <xsl:for-each select="/page/content/users/item">
                    <option value="{@id}">
                        <xsl:if test="$user/@id = current()/@id">
                            <xsl:attribute name="selected">selected</xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="@firstname"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="@lastname"/>
                    </option>
                </xsl:for-each>
            </select>
        </xsl:when>
        <xsl:otherwise>
            <input id="Name" class="text" type="text" name="name" placeholder="" value="{$user/@firstname} {$user/@lastname}"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>
