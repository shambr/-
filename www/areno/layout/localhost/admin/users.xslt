<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="../layout.xslt"/>

<xsl:template name="menu">
</xsl:template>

<xsl:template name="title">
    <xsl:text>Пользователи</xsl:text>
</xsl:template>

<xsl:template match="content/users">
    <p><a href="/admin/adduser">Добавить пользователя</a></p>

    <table border="1">
        <tr>
            <th>ID</th>
            <th>Имя</th>
            <th>Фамилия</th>
            <th>Ник</th>
            <th>E-mail</th>
            <th>Добавлен</th>
            <th>Кем создан</th>
            <th>Профессия</th>
            <th>Роль</th>
            <th>Телефон</th>
            <th>Скайп</th>
            <th>Теги интересов</th>
        </tr>
        <xsl:for-each select="item">
            <tr>
                <td>
                    <a href="/admin/edituser?id={@id}">
                        <xsl:value-of select="@id"/>
                    </a>
                </td>
                <td>
                    <xsl:value-of select="@firstname"/>
                </td>
                <td>
                    <xsl:value-of select="@lastname"/>
                </td>
                <td>
                    <xsl:value-of select="@username"/>
                </td>
                <td>
                    <xsl:value-of select="@email"/>
                </td>
                <td>
                    <xsl:value-of select="@created"/>
                </td>
                <td>
                    <xsl:value-of select="@createdby"/>
                </td>
                <td>
                    <xsl:value-of select="@occupation"/>
                </td>
                <td>
                    <xsl:value-of select="@status"/>
                </td>
                <td>
                    <xsl:value-of select="@phone"/>
                </td>
                <td>
                    <xsl:value-of select="@skype"/>
                </td>
                <td>
                    <xsl:value-of select="@tags"/>
                </td>
            </tr>
        </xsl:for-each>
    </table>
</xsl:template>

</xsl:stylesheet>
