<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="layout.xslt"/>


<xsl:template match="content/login">
    <div class="whitecontent">
        <form method="post">
            <h3>Ваши имя пользователя и пароль:</h3>
            <div>
                <input class="text" type="text" name="username" value="{/page/manifest/username}"/>
            </div>
            <br/>
            <div>
                <input class="text" type="password" name="password"/>
            </div>
            <br/>
            <div class="submit">
                <input class="wide" type="submit" value="ВОЙТИ"/>
            </div>
        </form>
    </div>
</xsl:template>

<xsl:template match="content/error">
    <p class="error">
        <xsl:value-of select="text()"/>
    </p>
</xsl:template>

</xsl:stylesheet>
