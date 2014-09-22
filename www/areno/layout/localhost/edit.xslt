<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="layout.xslt"/>

<xsl:template name="head">
    <script>
        function postQuestion() {
            return $('#Question').val().length != 0;
        }
    </script>
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
            <p></p>

            <h3 style="margin-top: 0">Ваш e-mail:</h3>
            <input id="Email" class="text" type="email" name="email" value="{$question/@email}" autocapitalize="off" />

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
