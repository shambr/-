<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="layout.xslt"/>

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

<xsl:template match="content/answers/item">
    <div class="list">
        <div class="questioncard">
            <div class="name">
                <xsl:value-of select="@name"/>
            </div>
            <div class="c{position() mod 8}">                
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

<xsl:template name="title">Ответы</xsl:template>

<xsl:template name="menu">
</xsl:template>

</xsl:stylesheet>
