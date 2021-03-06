<?xml version="1.0" encoding="UTF-8" ?>
<!-- (c) Copyright IBM Corp. 2004, 2005 All Rights Reserved. -->

<!--
        Standard error message template for DITA processing in XSL. This
        file should be included by any XSL program that uses the standard
        message template. To include this file, you will need the following
        two commands in your XSL:

<xsl:include href="output-message.xsl"/>           - Place with other included files

<xsl:variable name="msgprefix">DOTX</xsl:variable> - Place with other variables


        The template takes in the following parameters:
        - msg    = the message to print in the log; default=***
        - msgnum = the message number (3 digits); default=000
        - msgsev = the severity (I, W, E, or F); default=I (Informational)
-->


<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dtm="http://syntext.com/Extensions/DocumentTypeMetadata-1.0"
                extension-element-prefixes="dtm">


<dtm:doc dtm:status="testing" dtm:idref="output-message"/>
<xsl:template name="output-message" dtm:id="output-message">
  <xsl:param name="msg" select="***"/>
  <xsl:param name="msgnum" select="000"/>
  <xsl:param name="msgsev" select="I"/>
  <xsl:param name="msgparams" select="''"/>
  
  <xsl:variable name="msgid">
    <xsl:value-of select="$msgprefix"/>
    <xsl:value-of select="$msgnum"/>
    <xsl:value-of select="$msgsev"/>
  </xsl:variable>
  <xsl:variable name="msgdoc" select="document('../../resource/messages.xml')"/>
  <xsl:variable name="msgcontent">
    <xsl:apply-templates select="$msgdoc/messages/message[@id=$msgid]" mode="get-message-content">    
      <xsl:with-param name="params" select="$msgparams"/>    
    </xsl:apply-templates>
  </xsl:variable>
  <xsl:variable name="localclass"><xsl:value-of select="@class"/></xsl:variable>
  <xsl:variable name="debugloc">
   <!-- Information on how to find the error; file name, followed by element counter: -->
   <!-- (File = filename.dita, Element = searchtitle:1) -->
   <xsl:if test="@xtrf|@xtrc">
     <xsl:text>(</xsl:text>
     <xsl:if test="@xtrf">
       <xsl:text>File = </xsl:text><xsl:value-of select="@xtrf"/>
       <xsl:if test="@xtrc"><xsl:text>, </xsl:text></xsl:if>
     </xsl:if>
     <xsl:if test="@xtrc"><xsl:text>Element = </xsl:text><xsl:value-of select="@xtrc"/></xsl:if>
     <xsl:text>)</xsl:text>
   </xsl:if>
  </xsl:variable>
  
  <xsl:message><xsl:text>
</xsl:text>
    <xsl:value-of select="$debugloc"/>     <!-- Debug location, followed by a newline -->
    <xsl:text>
</xsl:text>
    <xsl:value-of select="$msgcontent"/>          <!-- Error message, followed by a newline -->
    <xsl:text>
</xsl:text>
  </xsl:message>
</xsl:template>

<dtm:doc dtm:status="testing" dtm:idref="message.get-content"/>
<xsl:template match="message" mode="get-message-content" dtm:id="message.get-content">
  <xsl:param name="params"/>
  <xsl:variable name="reason" select="reason/text()"/>
  <xsl:variable name="response" select="response/text()"/>    
  
  <xsl:text>[</xsl:text><xsl:value-of select="@id"/><xsl:text>]</xsl:text>
  <xsl:text>[</xsl:text><xsl:value-of select="@type"/><xsl:text>]</xsl:text>
  <xsl:text>: </xsl:text>
  <xsl:call-template name="replaceParams">
    <xsl:with-param name="string" select="$reason"/>
    <xsl:with-param name="params" select="$params"/>    
  </xsl:call-template>
  <xsl:text> </xsl:text>
  <xsl:call-template name="replaceParams">
    <xsl:with-param name="string" select="$response"/>
    <xsl:with-param name="params" select="$params"/>    
  </xsl:call-template>
</xsl:template>

<dtm:doc dtm:status="testing" dtm:idref="params.replace"/>
<xsl:template name="replaceParams" dtm:id="params.replace">
  <xsl:param name="string"/>
  <xsl:param name="params"/>
  <xsl:choose>
    <xsl:when test="contains($params,';')">
      <xsl:variable name="param" select="substring-before($params,';')"/>
      <xsl:variable name="newString">
        <xsl:call-template name="replaceString">
          <xsl:with-param name="string" select="$string"/>
          <xsl:with-param name="match" select="substring-before($param,'=')"/>
          <xsl:with-param name="replacement" select="substring-after($param,'=')"/>            
        </xsl:call-template>          
      </xsl:variable>
      <xsl:call-template name="replaceParams">
        <xsl:with-param name="string" select="$newString"/>
        <xsl:with-param name="params" select="substring-after($params,';')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="contains($params,'=')">
      <xsl:call-template name="replaceString">
        <xsl:with-param name="string" select="$string"/>
        <xsl:with-param name="match" select="substring-before($params,'=')"/>
        <xsl:with-param name="replacement" select="substring-after($params,'=')"/>            
      </xsl:call-template>   
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<dtm:doc dtm:status="testing" dtm:idref="string.replace"/>
<xsl:template name="replaceString" dtm:id="string.replace">
  <xsl:param name="string"/>
  <xsl:param name="match"/>
  <xsl:param name="replacement"/>
  <xsl:choose>
    <xsl:when test="contains($string, $match)">
      <xsl:variable name="newstring">
        <xsl:value-of select="concat(substring-before($string, $match), concat($replacement, substring-after($string, $match)))"/>
      </xsl:variable>
      <xsl:call-template name="replaceString">
        <xsl:with-param name="string" select="$newstring"/>
        <xsl:with-param name="match" select="$match"/>
        <xsl:with-param name="replacement" select="$replacement"/>                    
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
  
</xsl:stylesheet>
