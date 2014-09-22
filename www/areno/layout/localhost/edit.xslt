<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="layout.xslt"/>

<xsl:template name="head">
    <script>
        function postQuestion() {
            return $('#Question').val().length != 0;
        }
    </script>
    <script src="/js/jquery.switchButton.js"/>
    <link rel="stylesheet" type="text/css" href="/i/jquery.switchButton.css"/>
</xsl:template>

<xsl:template match="content/question">
    <xsl:variable name="question" select="/page/content/question"/>

    <div class="whitecontent">
        <form method="post" action="/edit" enctype="multipart/form-data" id="PostForm" onsubmit="return postQuestion();">
            <input type="hidden" name="save_id" value="{$question/@id}"/>

            <h3 id="QLabel">Какой вопрос вы хотите задать?</h3>
            <textarea id="Question" name="question" onkeypress="startTyping();">
                <xsl:value-of select="$question/text()"/>
            </textarea>

            <h3>Теги, чтобы найти вопрос:</h3>
            <input id="Tags" class="text" type="text" name="tags" value="{$question/@tags}" autocapitalize="off" />

            <h3>Как вас зовут?</h3>
            <input id="Name" class="text" type="text" name="name" value="{$question/@name}" />

            <h3>Ваш e-mail:</h3>
            <input id="Email" class="text" type="email" name="email" value="{$question/@email}" autocapitalize="off" />
        
            <h3 style="text-align: left;">
                <label>
                    <input type="checkbox" id="is_published" name="is_published" value="yes">
                        <xsl:if test="@is_published = 1">
                            <xsl:attribute name="checked">checked</xsl:attribute>
                        </xsl:if>
                    </input>
                    <xsl:text> Вопрос опубликован</xsl:text>
                </label>
            </h3>

            <div class="submit">
                <input name="submit" id="Submit" type="submit" value="Сохранить" />
            </div>
        </form>
    </div>
</xsl:template>

<xsl:template name="menu">
    <div class="menu">
        <div class="menu-item">
            <a onclick="history.back()">Назад</a>               
        </div>
        <div class="menu-item">
            <xsl:text>Вопрос</xsl:text>
        </div>
    </div>
</xsl:template>

</xsl:stylesheet>
