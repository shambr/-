<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="layout.xslt"/>

<xsl:template name="head">
    <xsl:if test="$is_moderator">
        <script src="/js/jquery-ui.min.js"></script>
    </xsl:if>

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

    <xsl:if test="$is_moderator">
            function remove_question(question_id) {
                if (!confirm('Удалить вопрос?')) return;

                $.ajax({
                    url: '/remove',
                    type: 'get',
                    data: {
                        id: question_id
                    }
                }).done(function() {
                    $('#card-' + question_id).hide('slow');
                });        
            }
        </xsl:if>
    </script>
</xsl:template>

<xsl:template match="content/list">
    <div class="list">
        <ul id="sortable">
            <xsl:apply-templates select="item"/>
        </ul>
    </div>

    <xsl:if test="$is_moderator">
        <script>
            $("#sortable").sortable({
                beforeStop: function() {
                    var questions = $('div.questioncard');
                    var ids = '';
                    for (var c = 0; c != questions.length; c++) {
                        ids += questions[c].id + ',';
                    }
                    ids = ids.replace(/card-/g, '');
                    ids = ids.replace(/,$/, '');
                    
                    $.ajax({
                        url: '/sort',
                        type: 'get',
                        data: {
                            ids: ids
                        }
                    });
                }
            });    
        </script>
    </xsl:if>
</xsl:template>

<xsl:template match="content/list/item">
    <li>
        <a name="{@id}"/>
        <div class="questioncard" id="card-{@id}">
            <div class="name">
                <xsl:value-of select="@name"/>
            </div>
            <div class="questionblock c{position() mod 8}">
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
                    <xsl:value-of select="@tags"/>                    
                </div>
                <div class="answers">
                    <img src="/i/answers.svg"/>
                    <xsl:if test="$is_moderator">
                        <xsl:text> </xsl:text>
                        <a href="/admin/invite?id={@id}" style="color: black; font-family: Arial; font-size: 80%">Пригласить ответить</a>
                        <xsl:text> </xsl:text>
                        <a href="/answers?id={@id}" style="color: black; font-family: Arial; font-size: 80%">Ответы</a>
                    </xsl:if>

                    <div class="buttons" id="buttons-{@id}">
                        <img src="/i/vote_minus.svg" onclick="vote({@id}, 'm')"/>
                        <img src="/i/vote_plus.svg" onclick="vote({@id}, 'p')"/>
                    </div>
                </div>

                <xsl:if test="$is_moderator">
                    <div class="moderation buttons">
                        <img src="/i/remove.svg" onclick="remove_question({@id})"/>
                        <br />
                        <img src="/i/edit.svg" onclick="document.location = '/edit?id={@id}'"/>
                    </div>
                </xsl:if>
            </div>
        </div>
    </li>
</xsl:template>

</xsl:stylesheet>
