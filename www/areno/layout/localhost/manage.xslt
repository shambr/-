<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="manage-layout.xslt"/>

<xsl:template name="head">
    <xsl:if test="$is_moderator">
        <script src="/js/jquery-ui.min.js"></script>
    </xsl:if>

    <script>
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
    </script>
</xsl:template>

<xsl:template match="content">
    <div>
        <xsl:variable name="current-filter1" select="/page/manifest/request/arguments/item[@name = 'filter1']"/>
        <form method="get()" class="filter" id="filterform">
            <select name="filter1" onchange="submit_filter()">
                <option value="all">
                    <xsl:if test="$current-filter1 = 'all'">
                        <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:text>Все вопросы</xsl:text>
                </option>
                <option value="notprocessed">
                    <xsl:if test="$current-filter1 = 'notprocessed'">
                        <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:text>Необработанные</xsl:text>
                </option>
                <option value="processed">
                    <xsl:if test="$current-filter1 = 'processed'">
                        <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:text>Обработанные</xsl:text>
                </option>
                <option value="notanswered">
                    <xsl:if test="$current-filter1 = 'notanswered'">
                        <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:text>Неотвеченные</xsl:text>
                </option>
                <option value="answered">
                    <xsl:if test="$current-filter1 = 'answered'">
                        <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:text>Отвеченные</xsl:text>
                </option>
                <option value="interesting">
                    <xsl:if test="$current-filter1 = 'interesting'">
                        <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:text>Интересные</xsl:text>
                </option>
                <option value="published">
                    <xsl:if test="$current-filter1 = 'published'">
                        <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:text>Опубликованные</xsl:text>
                </option>
                <option value="hidden">
                    <xsl:if test="$current-filter1 = 'hidden'">
                        <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:text>Скрытые</xsl:text>
                </option>
                <option value="removed">
                    <xsl:if test="$current-filter1 = 'removed'">
                        <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:text>Удаленные</xsl:text>
                </option>
            </select>
            <input type="text" name="filter2"/>
        </form>
        <div class="filter-count">
            <xsl:value-of select="count(list/item)"/>
        </div>
        <div style="clear: both"/>
    </div>

    <script>
        function submit_filter() {
            document.getElementById('filterform').submit();
        }        
    </script>

    <xsl:apply-templates select="list"/>
</xsl:template>

<xsl:template match="content/list">
    <table class="questions">
        <thead>
            <tr>
                <th>Вопрос</th>
                <th>Дата и время</th>
                <th>Статус вопроса</th>
                <th>Рейтинг</th>
                <th>Ответов</th>
                <th>Статус ответа</th>
                <th>Время</th>
                <th>Ответственный</th>
            </tr>
        </thead>
        <tbody>
            <xsl:apply-templates select="item"/>
        </tbody>
    </table>
</xsl:template>

<xsl:template match="content/list/item">
    <tr>
        <td rowspan="2" class="info" style="width: 40%">
            <div>
                <xsl:value-of select="@name"/>
            </div>
            <div>
                <xsl:value-of select="text()"/>
            </div>
        </td>
        <td>
            <nobr>
                <xsl:value-of select="@datetime"/>
            </nobr>
        </td>
        <td>
            <ul>
                <xsl:choose>
                    <xsl:when test="@is_removed = 0">
                        <xsl:choose>
                            <xsl:when test="@is_published">
                                <li>Опубликован</li>
                            </xsl:when>
                            <xsl:otherwise>
                                <li>Не опубликован</li>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <li>Удален</li>
                    </xsl:otherwise>
                </xsl:choose>
            </ul>
        </td>
        <td>
            <xsl:value-of select="@score"/>
        </td>

        <td>
        </td>
        <td>
        </td>
        <td>
        </td>
        <td>
        </td>
        <td rowspan="2" style="width: 1px;" class="info">
        </td>
    </tr>
    <tr class="info">
        <td colspan="4">
            <div class="actions">
                <span>Ответить</span>
                <span>Найти эксперта</span>
                <span>Редактировать</span>
                <span>Удалить</span>
            </div>
        </td>
        <td>
        </td>
        <td>
        </td>
        <td>
        </td>
    </tr>
</xsl:template>

</xsl:stylesheet>
