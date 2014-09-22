<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="layout.xslt"/>

<xsl:template name="head">
    <script>
        function vote(question_id, value) {
            $.ajax({
                url: '/vote',
                type: 'get',
                data: {
                    id: question_id,
                    vote: value
                }
            }).done(function() {
                var score = $('#score-' + question_id);
                score.text(value == 'p' ? +score.text() + 1 : score.text() - 1);

                $('#buttons-' + question_id).hide('slow');
            });
        }
    </script>
</xsl:template>

<xsl:template match="content/list">
    <div class="list">
        <xsl:apply-templates select="item"/>
    </div>
</xsl:template>

<xsl:template match="content/list/item">
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
            <div class="answers">
                <img src="/i/answers.svg"/>
                <div class="buttons" id="buttons-{@id}">
                    <img src="/i/vote_minus.svg" onclick="vote({@id}, 'm')"/>
                    <img src="/i/vote_plus.svg" onclick="vote({@id}, 'p')"/>
                </div>
            </div>
        </div>
    </div>
</xsl:template>

</xsl:stylesheet>
