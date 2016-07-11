<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/synonyms">
  <div>
    <xsl:apply-templates select="theme"/>
  </div>
</xsl:template>

<xsl:template match="theme">
  <section class="theme group" id="{@id}">
    <h1>
      <span class="title"><xsl:value-of select="title" /></span>
      <xsl:if test="learn-more">
        <small class="learn-more">
          <a href="{learn-more}" target="_blank">(Learn more)</a>
        </small>
      </xsl:if>
    </h1>
    <xsl:apply-templates select="synonym" />
  </section>
</xsl:template>

<xsl:template match="synonym">
  <section class="synonym" id="{@id}">
    <h4 class="section"><xsl:value-of select="title"/></h4>
    <div class="row codes">
      <xsl:apply-templates select="code"/>
    </div>
  </section>
</xsl:template>

<xsl:template match="code">
  <div class="col-md-6">
    <pre class="{@language}">
      <xsl:if test="@language='javascript'">
        <xsl:attribute name="class">prettyprint lang-js</xsl:attribute>
      </xsl:if>
      <xsl:if test="@language='dart'">
        <xsl:attribute name="class">prettyprint lang-dart</xsl:attribute>
      </xsl:if>
      <xsl:if test="@language='csharp'">
        <xsl:attribute name="class">prettyprint lang-csharp</xsl:attribute>
      </xsl:if>
      <xsl:if test="@language='python'">
        <xsl:attribute name="class">prettyprint lang-python</xsl:attribute>
      </xsl:if>
      <xsl:if test="@language='java'">
        <xsl:attribute name="class">prettyprint lang-java</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="." />
    </pre>
  </div>
</xsl:template>

</xsl:stylesheet>