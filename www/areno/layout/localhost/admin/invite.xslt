<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="../layout.xslt"/>

<xsl:template name="title">Пригласить ответить</xsl:template>

<xsl:template match="content/question">
    <div style="text-align: left">
        <h3 style="text-align: left">Вопрос</h3>
        <p style="text-align: left">
            <xsl:value-of select="text()"/>
        </p>
        <p style="text-align: left; font-size: 90%"><i>
            <xsl:value-of select="@name"/>, <xsl:value-of select="@datetime"/>
        </i></p>
    </div>
</xsl:template>

<xsl:template match="content/users">
    <form method="get">
        <input type="hidden" name="id" value="{/page/content/question/@id}"/>
        <p style="margin-top: 1em; text-align: left">
            Отвечает
            <select name="who">
                <xsl:for-each select="item">
                    <option value="{@id}">
                        <xsl:if test="/page/manifest/request/arguments/item[@name = 'who']/text() = current()/@id">
                            <xsl:attribute name="selected">selected</xsl:attribute>
                        </xsl:if>

                        <xsl:value-of select="@firstname"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="@lastname"/>
                    </option>
                </xsl:for-each>
            </select>
            <input type="submit" value="Получить ссылку"/>
            <p style="text-align: left; font-size: 90%;">
                <a href="/admin/users">Пользователи</a>
                <xsl:text> </xsl:text>
                <a href="/admin/adduser">Добавить пользователя</a>
            </p>
        </p>
    </form>
</xsl:template>

<xsl:template match="content/link">
    <input type="text" style="width: 40em" value="{text()}" onclick="this.select();"/>
</xsl:template>

<xsl:template name="menu">
    <div class="menu">
        <div class="menu-item">
            <a href="/all">Публичные</a>
        </div>
        <div class="menu-item">
            <a href="/allhidden">Скрытые</a>
        </div>
    </div>
</xsl:template>    


</xsl:stylesheet>
