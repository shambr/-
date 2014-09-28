<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="../layout.xslt"/>

<xsl:template name="menu">
</xsl:template>

<xsl:template name="title">
    <xsl:text>Добавить пользователя</xsl:text>
</xsl:template>

<xsl:template match="content/add-user">
    <form method="post">
        <table>
            <tr>
                <td>Ник</td>
                <td>
                    <input type="text" name="username" />
                </td>
            </tr>
            <tr>
                <td>Имя</td>
                <td>
                    <input type="text" name="firstname" />
                </td>
            </tr>
            <tr>
                <td>Фамилия</td>
                <td>
                    <input type="text" name="lastname" />
                </td>
            </tr>
            <tr>
                <td>Профессия</td>
                <td>
                    <input type="text" name="occupation" />
                </td>
            </tr>
            <tr>
                <td>E-mail</td>
                <td>
                    <input type="text" name="email" />
                </td>
            </tr>
            <tr>
                <td>Телефон</td>
                <td>
                    <input type="text" name="phone" />
                </td>
            </tr>
            <tr>
                <td>Скайп</td>
                <td>
                    <input type="text" name="skype" />
                </td>
            </tr>
            <tr>
                <td>Теги интересов</td>
                <td>
                    <input type="text" name="tags" />
                </td>
            </tr>
            <tr>
                <td>Пароль</td>
                <td>
                    <input type="text" name="password" />
                </td>
            </tr>
            <tr>
                <td>Роль</td>
                <td>
                    <label>
                        <input type="radio" name="status" value="journalist" checked="checked"/> журналист
                    </label>
                    <label>
                        <input type="radio" name="status" value="moderator"/> модератор
                    </label>
                    <label>
                        <input type="radio" name="status" value="expert"/> эксперт
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
