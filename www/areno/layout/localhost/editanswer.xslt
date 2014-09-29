<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="layout.xslt"/>

<xsl:template match="content/answer">
    <div class="whitecontent">
        <form method="post" action="/editanswer" enctype="multipart/form-data" id="PostForm">
            <input type="hidden" name="edit_id" value="{@id}"/>
            <h3>Ваше имя:</h3>
            <input id="Name" class="text" type="text" name="name" value="{@name}" />

            <h3 id="QLabel">Ваш ответ:</h3>
            <textarea id="Answer" name="answer">
                <xsl:value-of select="text()"/>
            </textarea>

            <p style="align: left; margin-top: 1em;">
                <label>
                    <input type="checkbox" name="is_published" value="yes">
                        <xsl:if test="@is_published = 1">
                            <xsl:attribute name="checked">checked</xsl:attribute>
                        </xsl:if>
                    </input>
                    <xsl:text> опубликовано</xsl:text>
                </label>
            </p>

            <div class="submit">
                <input name="submit" id="Submit" type="submit" value="Сохранить ответ" />
            </div>
        </form>
    </div>
</xsl:template>

<xsl:template name="title">Редактирование вопроса</xsl:template>
<xsl:template name="menu">
</xsl:template>

</xsl:stylesheet>
