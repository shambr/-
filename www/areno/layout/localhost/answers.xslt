<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="layout.xslt"/>
<xsl:include href="elements.xslt"/>

<xsl:template name="head">
    <script>
        var answerPosted = 0;

        function postAnswer() {
            return $('#Answer').val().length != 0;
        }

        function startTyping() {
            if (answerPosted) {
                $('#Message').fadeOut(1000);
            }

            answerPosted = 0;

            if ($('#Answer').val().replace(/^[ \\n\\t]+/, '').replace(/[ \\n\\t]+\$/, '').length != 0) {
                $('#Submit').addClass("enabled");
                $('#Submit').removeClass("disabled");
            }
            else {
                $('#Submit').addClass("disabled");
                $('#Submit').removeClass("enabled");
            }
        }

        function clear_form() {
            $('#Answer').val('');
            $('#Tags').val('');
        }

        function remove_answer(answer_id) {
            if (!confirm('Удалить ответ?')) return;

            $.ajax({
                url: '/remove',
                type: 'get',
                data: {
                    type: 'answer',
                    id: answer_id
                }
            }).done(function() {
                $('#card-' + answer_id).hide('slow');
            });        
        }


        var answerPosted = 0;

        function postAnswer() {
            return $('#Answer').val().length != 0;
        }

        function startTyping() {
            if (answerPosted) {
                $('#Message').fadeOut(1000);
            }

            answerPosted = 0;

            if ($('#Answer').val().replace(/^[ \\n\\t]+/, '').replace(/[ \\n\\t]+\$/, '').length != 0) {
                $('#Submit').addClass("enabled");
                $('#Submit').removeClass("disabled");
            }
            else {
                $('#Submit').addClass("disabled");
                $('#Submit').removeClass("enabled");
            }
        }

        function clear_form() {
            $('#Answer').val('');
            $('#Tags').val('');
        }
    </script>
</xsl:template>

<xsl:template match="content/question">
    <div class="list">
        <div class="questioncard">
            <div class="name">
                <xsl:value-of select="@name"/>
            </div>
            <div class="c{position() mod 8}">
                <div class="score" id="score-{@id}">
                    <xsl:value-of select="@score"/>
                </div>
                <div class="text">
                    <xsl:if test="string-length(text()) &gt; 100">
                        <xsl:attribute name="class">text text1</xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="text()"/>
                </div>            
            </div>
        </div>
    </div>    
</xsl:template>

<xsl:template match="content/answers">
    <div style="padding-bottom: 2em">
        <xsl:apply-templates select="item"/>
    </div>

    <xsl:call-template name="answer-form"/>
</xsl:template>

<xsl:template match="answers/item">
    <div class="list" id="card-{@id}">
        <div class="questioncard">
            <xsl:if test="@is_published = 0">
                <xsl:attribute name="style">border: 2px dashed gray; margin-top: 0.5em</xsl:attribute>
            </xsl:if>
            <div class="name">
                <xsl:value-of select="@name"/>
            </div>
            <div class="questionblock c{(position() + 1) mod 8}">                
                <div class="text">
                    <xsl:if test="string-length(text()) &gt; 100">
                        <xsl:attribute name="class">text text1</xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="text()" disable-output-escaping="yes"/>
                </div>            
                <div class="moderation buttons">
                    <img src="/i/remove.svg" onclick="remove_answer({@id})"/>
                    <br />
                    <img src="/i/edit.svg" onclick="document.location = '/editanswer?id={@id}'"/>
                </div>
            </div>
        </div>
    </div>
</xsl:template>

<xsl:template name="answer-form">
    <div class="whitecontent">
        <form method="post" action="/postanswer" enctype="multipart/form-data" id="PostForm" onsubmit="return postAnswer();">
            <input type="hidden" name="answer_to" value="{/page/content/question/@id}"/>

            <xsl:call-template name="your-name"/>            

            <h3 id="QLabel">Ваш ответ:</h3>
            <textarea id="Answer" name="answer" placeholder="" onkeypress="startTyping();" onclick="startTyping();"></textarea>

            <div class="submit">
                <input name="submit" id="Submit" class="disabled" type="submit" value="Отправить ответ" />
            </div>
        </form>
    </div>
</xsl:template>

<xsl:template name="title">Ответы</xsl:template>

<xsl:template name="menu">
</xsl:template>

</xsl:stylesheet>
