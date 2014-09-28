<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="../layout.xslt"/>

<xsl:template name="menu">
</xsl:template>

<xsl:template name="title">
    <xsl:text>Редактирование пользователя</xsl:text>
</xsl:template>

<xsl:template match="content/user">
    <form method="post">
        <input type="hidden" name="id" value="{@id}"/>
        <table>
            <tr>
                <td>Ник</td>
                <td>
                    <input type="text" name="username" value="{@username}"/>
                </td>
            </tr>
            <tr>
                <td>Имя</td>
                <td>
                    <input type="text" name="firstname" value="{@firstname}"/>
                </td>
            </tr>
            <tr>
                <td>Фамилия</td>
                <td>
                    <input type="text" name="lastname" value="{@lastname}"/>
                </td>
            </tr>
            <tr>
                <td>Профессия</td>
                <td>
                    <input type="text" name="occupation" value="{@occupation}"/>
                </td>
            </tr>
            <tr>
                <td>E-mail</td>
                <td>
                    <input type="text" name="email" value="{@email}"/>
                </td>
            </tr>
            <tr>
                <td>Телефон</td>
                <td>
                    <input type="text" name="phone" value="{@phone}"/>
                </td>
            </tr>
            <tr>
                <td>Скайп</td>
                <td>
                    <input type="text" name="skype" value="{@skype}"/>
                </td>
            </tr>
            <tr>
                <td>Теги интересов</td>
                <td>
                    <input type="text" name="tags" value="{@tags}"/>
                </td>
            </tr>
            <tr>
                <td>Пароль</td>
                <td>
                    <input type="text" name="password"/>
                </td>
            </tr>
            <tr>
                <td>Роль</td>
                <td>
                    <label>
                        <input type="radio" name="status" value="journalist">
                            <xsl:if test="@status = 'journalist'">
                                <xsl:attribute name="checked">checked</xsl:attribute>
                            </xsl:if>
                        </input>
                        <xsl:text> журналист</xsl:text>
                    </label>
                    <label>
                        <input type="radio" name="status" value="moderator">
                            <xsl:if test="@status = 'moderator'">
                                <xsl:attribute name="checked">checked</xsl:attribute>
                            </xsl:if>
                        </input>
                        <xsl:text> модератор</xsl:text>
                    </label>
                    <label>
                        <input type="radio" name="status" value="expert">
                            <xsl:if test="@status = 'expert'">
                                <xsl:attribute name="checked">checked</xsl:attribute>
                            </xsl:if>
                        </input>
                        <xsl:text> эксперт</xsl:text>
                    </label>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type="submit" value="ОК" name="submit"/>
                </td>
            </tr>
        </table>
    </form>
</xsl:template>

</xsl:stylesheet>
