<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" version="1.0">
						

			<xsl:output method="html"/>
			<!-- ********************************************************* -->
			<!-- This stylesheet is used to display the output of comments -->
			<!-- ********************************************************* -->

			<xsl:template match="/">

			<HTML>
						<HEAD></HEAD>
						<BODY>

									<xsl:apply-templates/>

						</BODY>
			</HTML>

			</xsl:template>
			
			<xsl:template match="NAV_HEADER">
	<TABLE style="solid blue;background-color:RGB(200,200,200)" height="50" width="360" border="1">
	<TR>
		<TD>
			<TABLE border="1">
			<TR>
				<TD align="left" width="100">
					<SPAN style="font-size:10pt;font-weight:bold;color:black;">
					Previous:
					</SPAN>
				</TD>
				<TD align="right" width="260">
					<SPAN style="font-size:10pt;font-weight:bold;color:green">			
					<xsl:value-of select="PREV"/><BR/>
					</SPAN>		
				</TD>	
			</TR>
			<TR>
				<TD align="left" width="100">
					<SPAN style="font-size:10pt;font-weight:bold;color:black;">
					Next: 
					</SPAN>
				</TD>
				<TD align="right" width="260">
					<SPAN style="font-size:10pt;font-weight:bold;color:green">			
					<xsl:value-of select="NEXT"/><BR/>
					</SPAN>		
				</TD>
			</TR>
			<TR>
				<TD align="left" width="100">
					<SPAN style="font-size:10pt;font-weight:bold;color:black;">
					Display: 
					</SPAN>
				</TD>
				<TD align="right" width="260">
					<SPAN style="font-size:10pt;font-weight:bold;color:green">			
					<xsl:value-of select="DISP"/><BR/>
					</SPAN>
				</TD>	
			</TR>
			<TR>
				<TD align="left" width="100">
					<SPAN style="font-size:10pt;font-weight:bold;color:black;">
					Folder Docs: 
					</SPAN>
				</TD>
				<TD align="right" width="260">
					<SPAN style="font-size:10pt;font-weight:bold;color:green">			
					<xsl:value-of select="FOLDER_DOCS"/><BR/>
					</SPAN>
				</TD>
			</TR>							
			<TR>
				<TD align="left" width="100">
					<SPAN style="font-size:10pt;font-weight:bold;color:black;">
					Issue Docs:
					</SPAN>
				</TD>
				<TD align="right" width="260">
					<SPAN style="font-size:10pt;font-weight:bold;color:green">
					<xsl:value-of select="ISSUE_DOCS"/><BR/>
					</SPAN>
				</TD>
			</TR>							
					
			<TR>
				<TD align="left" width="100">
					<SPAN style="font-size:10pt;font-weight:bold;color:black;">			
					Publ Date:
					</SPAN>
				</TD>
				
	
	<TD align="right" width="260">
					<xsl:for-each select="PUBL_DATE">
					<SPAN style="font-size:10pt;font-weight:bold;color:green">
					<xsl:value-of select="PUBL_DAY"/>&#xA0;&#xA0;
					<xsl:value-of select="PUBL_MONTH"/>&#xA0;&#xA0;
					<xsl:value-of select="PUBL_YEAR"/><BR/>
					</SPAN>	
				 </xsl:for-each>
				</TD>
			</TR>							
			</TABLE>					
		</TD>
	</TR>
	</TABLE><BR/>	
</xsl:template>
		
			<xsl:template match="ADD"><SPAN style="color:rgb(236,118,0);"><xsl:apply-templates/></SPAN></xsl:template>		

			<xsl:template match="AQ"><SPAN style="background:rgb(224,224,224);"><xsl:apply-templates/></SPAN></xsl:template>	
			
			<xsl:template match="AUCTOR"><SPAN style="background:rgb(150,210,255);"><xsl:apply-templates/>
						<xsl:if test="@cont"><SPAN style="color:red"><SUP><I><xsl:value-of select="@cont"/></I></SUP></SPAN></xsl:if>
						<xsl:if test="@cont"><xsl:if test="@rep">&#xA0;</xsl:if></xsl:if>
						<xsl:if test="@rep"><SPAN style="color:red"><SUP><I><xsl:value-of select="@rep"/></I></SUP></SPAN></xsl:if></SPAN>
			</xsl:template>		

			<xsl:template match="B"><B><xsl:apply-templates/></B></xsl:template>
			
			<xsl:template match="BL"><SPAN style="background:rgb(223,255,223);"><xsl:apply-templates/></SPAN></xsl:template>
				
			<xsl:template match="C"><SPAN style="font:small-caps 12pt/14pt"><xsl:apply-templates/></SPAN></xsl:template>

			<xsl:template match="CAPTION"><SPAN style="background:khaki"><xsl:apply-templates/></SPAN></xsl:template>
			
			<xsl:template match="CELL">
										<TD><xsl:attribute name="style">border: 1px solid black;vertical-align:top;</xsl:attribute>
															<xsl:if test="@colspan">
																				<xsl:attribute name="colspan"><xsl:value-of select="@colspan"/></xsl:attribute>
															</xsl:if>
															<xsl:if test="@rowspan">
																				<xsl:attribute name="rowspan"><xsl:value-of select="@rowspan"/></xsl:attribute>
															</xsl:if>
															<xsl:apply-templates/></TD>
			</xsl:template>
			
			<xsl:template match="COMMENT"><P><xsl:apply-templates/></P></xsl:template>

			<xsl:template match="DATE"><SPAN style="color:rgb(0,128,0);"><xsl:apply-templates/></SPAN></xsl:template>
			
			<xsl:template match="DATERANGE"><SPAN style="color:rgb(128,0,128);"><xsl:apply-templates/></SPAN></xsl:template>
					
			<xsl:template match="DISLOCATED">
									<xsl:if test="@insLoc">
											<xsl:variable name="url" select="@url"/>
												<xsl:variable name="id" select="@id"/>
												<xsl:element name="A">																														
															<xsl:attribute name="href">javascript:void(0)</xsl:attribute>
															<xsl:attribute name="style">color:red;text-decoration:none;</xsl:attribute>															
															<xsl:element name="SPAN">
																		<xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
																		<xsl:attribute name="onMouseOver">showApTable('<xsl:value-of select="$id"/>','<xsl:value-of select="./."/>','<xsl:value-of select="@insLoc"/>');</xsl:attribute>
																		<xsl:attribute name="onMouseOut">hideApTable('<xsl:value-of select="$id"/>', '(DISLOCATED)');</xsl:attribute>
																		(DISLOCATED)
															</xsl:element>
												</xsl:element>
									</xsl:if>									
			</xsl:template>				

			<xsl:template match="DIV_END">
						<TABLE style="border: 0px solid black;">
									<TR><TD style="width:50px;">&#xA0;</TD><TD><HR style="color:red;width:300px;"/></TD></TR>
						</TABLE>
			</xsl:template>
						
			<xsl:template match="DIV_START">
						<TABLE style="border: 0px solid black;">
									<TR><TD style=" border: 1px solid black; width:50px;"><xsl:value-of select="@author"/>&#xA0;<xsl:value-of select="@cat"/>&#xA0;<xsl:value-of select="@index"/>&#xA0;<xsl:value-of select="@ref"/>&#xA0;<xsl:value-of select="@type"/>&#xA0;</TD><TD><HR style="color:blue;width:300px;"/></TD></TR>
						</TABLE>
			</xsl:template>
				
			<xsl:template match="DITTO">
									<xsl:choose>
												<xsl:when test="@rend[.='(empty)']">
															EMPTY&#xA0;
												</xsl:when>
												<xsl:otherwise>&#xA0;&#xA0;&#xA0;<xsl:value-of select="@rend"/>&#xA0;&#xA0;&#xA0;</xsl:otherwise>												
									</xsl:choose>
									<xsl:apply-templates/>
			</xsl:template>
				
			<xsl:template match="DOCUMENT"><xsl:apply-templates/></xsl:template>
						
			<xsl:template match="DOUBT"><SPAN style="color:rgb(128,0,255);"><xsl:apply-templates/></SPAN></xsl:template>					
					
			<xsl:template match="ERR"><SPAN style="color:rgb(255,0,0);"><xsl:apply-templates/></SPAN></xsl:template>
						
			<xsl:template match="FIELD">
												<xsl:choose>
															<xsl:when test="@rend[.='underlined']"><SPAN>____________________</SPAN></xsl:when>
																					<xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
												</xsl:choose>
			</xsl:template>
			
			<xsl:template match="FT">
									<xsl:choose>
												<xsl:when test="@r_text">
															<P style="width:400px;text-align:right"><xsl:value-of select="@r_text"/></P>
												</xsl:when>
												<xsl:when test="@l_text">
															<P style="width:480px;text-align:left"><xsl:value-of select="@l_text"/></P>
												</xsl:when>
												<xsl:when test="@c_text">
															<P style="width:480px;text-align:center"><xsl:value-of select="@c_text"/></P>
												</xsl:when>
									</xsl:choose>
			</xsl:template>
		
			<xsl:template match="HD">
						<xsl:if test="CTEXT|RTEXT|LTEXT">
									<TABLE border="0" width="400"><TR>
									<TD>
												<xsl:choose>
												<xsl:when test="LTEXT">
															<DIV Style="text-align:left;"><xsl:apply-templates select="LTEXT"/></DIV>
												</xsl:when>
												<xsl:otherwise>
															&#160;
												</xsl:otherwise>
										</xsl:choose>
									</TD>

									<TD>
										<xsl:choose>
												<xsl:when test="CTEXT">
														<DIV Style="text-align:center;"><xsl:apply-templates select="CTEXT"/></DIV>
												</xsl:when>
												<xsl:otherwise>
														&#160;
												</xsl:otherwise>
										</xsl:choose>
								</TD>

								<TD>
										<xsl:choose>
												<xsl:when test="RTEXT">
														<DIV Style="text-align:right;"><xsl:apply-templates select="RTEXT"/></DIV>
												</xsl:when>
												<xsl:otherwise>
														&#160;
												</xsl:otherwise>
										</xsl:choose>
							</TD>
						</TR></TABLE>
				</xsl:if>

				<xsl:if test="@lineType">
						<xsl:choose>
								<xsl:when test="@lineType[.='1']">
										<HR Style="text-align:left;width:400;"/>
								</xsl:when>
						</xsl:choose>
				</xsl:if>
			</xsl:template>
									
									<!-- *************************************************** -->					
									<!-- *****   TEMPLATES for HR   ************************ -->					
									<!-- *************************************************** -->					
									<xsl:template name="emDash">
												<xsl:param name="i"/>
															<xsl:if test="$i &gt; 0">&#x2014;<xsl:call-template name="emDash">
												<xsl:with-param name="i" select="$i - 1"/></xsl:call-template></xsl:if>
												
									</xsl:template>

									<xsl:template name="doubleEmdash">
												<xsl:param name="i"/>
															<xsl:if test="$i &gt; 0">&#x2550;<xsl:call-template name="doubleEmdash">
												<xsl:with-param name="i" select="$i - 1"/></xsl:call-template></xsl:if>
									</xsl:template>			

									<xsl:template name="emDashBlank">
												<xsl:param name="i"/>
															<xsl:if test="$i &gt; 0">
																				&#xA0;&#x2014;&#xA0;<xsl:call-template name="emDashBlank">
												<xsl:with-param name="i" select="$i - 1"/></xsl:call-template></xsl:if>
									</xsl:template>
			
									<xsl:template match="HR">
												<xsl:choose>
												
															<xsl:when test="@type[.='dotted']"><P><SPAN>................................</SPAN></P></xsl:when>
									
															<xsl:when test="@type[.='inline']">
																		<xsl:call-template name="emDash">
																					<xsl:with-param name="i" select="@emDashNum"/>
															</xsl:call-template>
															
															</xsl:when>
												
															<xsl:when test="@type[.='DoubleInline']">
																		<xsl:call-template name="doubleEmdash">
																					<xsl:with-param name="i" select="@emDashNum"/>
																		</xsl:call-template>
															</xsl:when>
												
															<xsl:when test="@type[.='emDash']">
																		<xsl:call-template name="emDashBlank">
																					<xsl:with-param name="i" select="@emDashNum"/>
																		</xsl:call-template><BR/>
															</xsl:when>
												
															<xsl:otherwise><HR style="text-align:left;width:500px"/></xsl:otherwise>
												
												</xsl:choose>
									</xsl:template>

		<xsl:template match="HYPH1">
										<xsl:choose>
															<xsl:when test="@cont">
																		<xsl:attribute name="cont"><xsl:value-of select="@cont"/></xsl:attribute>
															</xsl:when>
												</xsl:choose>
															<xsl:apply-templates/>&#xA0;&#xA0;<SPAN style="color:red">(<xsl:value-of select="@cont"/>)</SPAN>
			</xsl:template>

			<xsl:template match="HYPH2"><xsl:apply-templates/></xsl:template>
			
			<xsl:template match="I"><I><xsl:apply-templates/></I></xsl:template>
		
			<xsl:template match="ILLEGIBLE"><SPAN style="color:green">&#xA0;ILLEGIBLE&#xA0;</SPAN></xsl:template>
					
			<xsl:template match="IMG">
						<xsl:choose>
									<xsl:when test="parent::CELL"><TABLE style="border: 3px solid olivedrab;font-size:8pt;padding:3px 3px 3px 3px;"><TR><TD style="border: 1px solid black;width:150px;height:100px;"><xsl:apply-templates/></TD></TR></TABLE></xsl:when>
									<xsl:otherwise>
												<TABLE style="border: 3px solid olivedrab;font-size:8pt;margin-left:100px;">
																		<TR><TD style="border: 1px solid black;width:150px;height:100px;"><xsl:apply-templates/></TD></TR>
												</TABLE>
									</xsl:otherwise>
							</xsl:choose>
			</xsl:template>
			
			<xsl:template match="IMAGE_SEGMENT"></xsl:template>

			<xsl:template match="IN"><SPAN style="font-size:14pt;"><xsl:apply-templates/></SPAN></xsl:template>

			<xsl:template match="INS_LOC">
									<SPAN style="color:red">
												<xsl:variable name="idd" select="@id"/>
												<xsl:variable name="disjunctor" select="//DISLOCATED[@id=$idd]/@disjunctor"/>
												<xsl:variable name="text" select="//DISLOCATED[@id=$idd]"/>
												<xsl:value-of select="$disjunctor"/><xsl:value-of select="$text"/>
									</SPAN>
			</xsl:template>				
			
			<xsl:template match="L"><xsl:apply-templates/><BR/></xsl:template>
			
			<xsl:template match="LABEL"><SPAN style="background:goldenrod"><xsl:apply-templates/></SPAN></xsl:template>
						
			<xsl:template match="LANG">
								<SPAN style="color:darkblue"><xsl:apply-templates/>
											<xsl:if test="@iso"><SPAN style="color:darkblue"><SUP><xsl:value-of select="@iso"/></SUP></SPAN></xsl:if>
												<xsl:if test="@iso"><xsl:if test="@script">&#xA0;</xsl:if></xsl:if>
												<xsl:if test="@iso"><xsl:if test="@type">&#xA0;</xsl:if></xsl:if>
												<xsl:if test="@script"><SPAN style="color:darkblue"><SUP><xsl:value-of select="@script"/></SUP></SPAN></xsl:if>
												<xsl:if test="@script"><xsl:if test="@type">&#xA0;</xsl:if></xsl:if>
												<xsl:if test="@type"><SPAN style="color:darkblue"><SUP><xsl:value-of select="@type"/></SUP></SPAN></xsl:if>
									</SPAN>
			</xsl:template>
						
			<xsl:template match="LE"><xsl:apply-templates/><BR/></xsl:template>
						
			<xsl:template match="LG">
									<SPAN style="color:rgb(0,128,0);">
												<xsl:choose>
															<xsl:when test="./IN"><P class="fl"><xsl:apply-templates/></P></xsl:when>
															<xsl:when test="@rend[.='aq']"><SPAN style="background:rgb(224,224,224);"><P><xsl:apply-templates/></P></SPAN></xsl:when>
															<xsl:when test="@rend[.='bl']"><SPAN style="background:rgb(232,255,232);"><P><xsl:apply-templates/></P></SPAN></xsl:when>
															<xsl:otherwise>
																		<P><xsl:apply-templates/></P>
															</xsl:otherwise>												
												</xsl:choose>
									</SPAN>
			</xsl:template>
						
			<xsl:template match="NAME">
								<SPAN style="background:rgb(210,210,255);"><xsl:apply-templates/>
											<xsl:if test="@cont"><SPAN style="color:red"><SUP><I><xsl:value-of select="@cont"/></I></SUP></SPAN></xsl:if>
												<xsl:if test="@cont"><xsl:if test="@rep">&#xA0;</xsl:if></xsl:if>
												<xsl:if test="@cont"><xsl:if test="@type">&#xA0;</xsl:if></xsl:if>
												<xsl:if test="@rep"><SPAN style="color:red"><SUP><I><xsl:value-of select="@rep"/></I></SUP></SPAN></xsl:if>
												<xsl:if test="@rep"><xsl:if test="@type">&#xA0;</xsl:if></xsl:if>
												<xsl:if test="@type"><SPAN style="color:red"><SUP><I><xsl:value-of select="@type"/></I></SUP></SPAN></xsl:if>
									</SPAN>
			</xsl:template>
						
			<xsl:template match="NC">
									<SPAN style="background:rgb(210,210,255);"><xsl:apply-templates/>
												<xsl:if test="@cont"><SPAN style="color:red"><SUP><I><xsl:value-of select="@cont"/></I></SUP></SPAN></xsl:if>
												<xsl:if test="@cont"><xsl:if test="@pos">&#xA0;</xsl:if></xsl:if>
												<xsl:if test="@cont"><xsl:if test="@nameType">&#xA0;</xsl:if></xsl:if>
												<xsl:if test="@pos"><SPAN style="color:red"><SUP><I><xsl:value-of select="@pos"/></I></SUP></SPAN></xsl:if>
												<xsl:if test="@pos"><xsl:if test="@nameType">&#xA0;</xsl:if></xsl:if>
												<xsl:if test="@nameType"><SPAN style="color:red"><SUP><I><xsl:value-of select="@nameType"/></I></SUP></SPAN></xsl:if>
									</SPAN>
			</xsl:template>

			<xsl:template match="P">
									<xsl:element name="P">
												<xsl:choose>
															<xsl:when test="./IN"><xsl:attribute name="class">fl</xsl:attribute><xsl:if test="@style"><xsl:attribute name="style"><xsl:value-of select="@style"/></xsl:attribute></xsl:if><xsl:apply-templates/></xsl:when>
															<xsl:when test="@rend[.='aq']"><SPAN style="background:rgb(224,224,224);"><P><xsl:apply-templates/></P></SPAN></xsl:when>
															<xsl:when test="@rend[.='bl']"><SPAN style="background:rgb(232,255,232);"><P><xsl:apply-templates/></P></SPAN></xsl:when>
															<xsl:otherwise>
																		<xsl:if test="@style">
																					<xsl:attribute name="style"><xsl:value-of select="@style"/></xsl:attribute>
																		</xsl:if>
																		<xsl:apply-templates/>
															</xsl:otherwise>																								
												</xsl:choose>
									</xsl:element>
			</xsl:template>
						
			<xsl:template match="PAGE"><xsl:apply-templates/></xsl:template>
			
			<xsl:template match="ROW">
										<TR><xsl:apply-templates/></TR>
			</xsl:template>		
						
			<xsl:template match="SD"><SPAN style="background:rgb(255,185,255)"><xsl:apply-templates/></SPAN></xsl:template>
						
			<xsl:template match="SEGMENT_POS"></xsl:template>
			
			<xsl:template match="SEPARATOR">
										<xsl:choose>
															<xsl:when test="@type[.='asterisk']"><CENTER><P>*</P></CENTER></xsl:when>
															<xsl:when test="@type[.='asterism']"><CENTER><P>*&#xA0;&#xA0;*&#xA0;&#xA0;*</P></CENTER></xsl:when>
															<xsl:when test="@type[.='asterismUp']"><CENTER><P>*</P><P>*&#xA0;*</P></CENTER></xsl:when>
															<xsl:when test="@type[.='asterismDown']"><CENTER><P>*&#xA0;*</P><P>*</P></CENTER></xsl:when>
															<xsl:when test="@type[.='hr']"><CENTER><HR style="width:100px"/></CENTER></xsl:when><xsl:when test="@type[.='undefined']"><CENTER><P>???</P></CENTER></xsl:when>
															<xsl:when test="@type[.='vignetteTorch']"><SPAN style="color:green"><B>VT</B></SPAN></xsl:when>
										</xsl:choose>
			</xsl:template>
			
			<xsl:template match="SIGNATURE">
									<SPAN style="background:chocolate">SIGNATURE
												<xsl:choose>
															<xsl:when test="@cont"><xsl:attribute name="cont"><xsl:value-of select="@cont"/></xsl:attribute></xsl:when>
												</xsl:choose>
												
												<xsl:apply-templates/><SPAN><SUP><I><xsl:value-of select="@cont"/></I></SUP></SPAN></SPAN>
												
						</xsl:template>
			
			<xsl:template match="SIDEHEAD"><SPAN style="font-size:14pt;"><xsl:apply-templates/></SPAN></xsl:template>
						
			<xsl:template match="SOURCE"><SPAN style="color:rgb(128,0,255);"><xsl:apply-templates/></SPAN></xsl:template>
				
			<xsl:template match="SPAN">
								<SPAN style="background:springgreen"><xsl:apply-templates/>
											<xsl:if test="@cont"><SPAN><SUP><I><xsl:value-of select="@cont"/></I></SUP></SPAN></xsl:if>
												<xsl:if test="@cont"><xsl:if test="@norm">&#xA0;</xsl:if></xsl:if>
												<xsl:if test="@cont"><xsl:if test="@sug">&#xA0;</xsl:if></xsl:if>
												<xsl:if test="@cont"><xsl:if test="@type">&#xA0;</xsl:if></xsl:if>
												<xsl:if test="@norm"><SPAN><SUP><I><xsl:value-of select="@norm"/></I></SUP></SPAN></xsl:if>
												<xsl:if test="@norm"><xsl:if test="@sug">&#xA0;</xsl:if></xsl:if>
												<xsl:if test="@norm"><xsl:if test="@type">&#xA0;</xsl:if></xsl:if>
												<xsl:if test="@sug"><SPAN><SUP><I><xsl:value-of select="@sug"/></I></SUP></SPAN></xsl:if>
												<xsl:if test="@type"><SPAN><SUP><I><xsl:value-of select="@type"/></I></SUP></SPAN></xsl:if>
									</SPAN>
			</xsl:template>
						
			<xsl:template match="SPC"><SPAN style="color:rgb(0,0,255);letter-spacing:0.2em"><xsl:apply-templates/></SPAN></xsl:template>				
					
			<xsl:template match="SPK"><SPAN style="background:rgb(176,216,255);"><xsl:apply-templates/></SPAN></xsl:template>

			<xsl:template match="STYLESHEET"></xsl:template>

			<xsl:template match="SUB"><SUB><SPAN style="font-size:smaller;"><xsl:apply-templates/></SPAN></SUB></xsl:template>				
					
			<xsl:template match="SUP"><SUP><SPAN style="font-size:smaller;"><xsl:apply-templates/></SPAN></SUP></xsl:template>		

			<xsl:template match="SYMBOL">
										<xsl:choose>
															<xsl:when test="@type[.='blEtc']"><SPAN style="color:rgb(128,0,255);">blEtc</SPAN></xsl:when>
															<xsl:when test="@type[.='equals']">=</xsl:when>
															<xsl:when test="@type[.='dots']"><SPAN style="color:red">........</SPAN></xsl:when>
															<xsl:when test="@type[.='2dots']"><SPAN style="background:rgb(255,255,168);">..</SPAN></xsl:when>
															<xsl:when test="@type[.='3dots']"><SPAN style="background:rgb(255,255,168);">&#x2026;</SPAN></xsl:when>
															<xsl:when test="@type[.='4dots']"><SPAN style="background:rgb(255,255,168);">....</SPAN></xsl:when>
															<xsl:when test="@type[.='5dots']"><SPAN style="background:rgb(255,255,168);">.....</SPAN></xsl:when>
															<xsl:when test="@type[.='6dots']"><SPAN style="background:rgb(255,255,168);">......</SPAN></xsl:when>
															<xsl:when test="@type[.='2dotsEditor']"><SPAN style="color:rgb(255,128,0);">..</SPAN></xsl:when>
															<xsl:when test="@type[.='3dotsEditor']"><SPAN style="color:rgb(255,128,0);">&#x2026;</SPAN></xsl:when>
															<xsl:when test="@type[.='4dotsEditor']"><SPAN style="color:rgb(255,128,0);">....</SPAN></xsl:when>
															<xsl:when test="@type[.='5dotsEditor']"><SPAN style="color:rgb(255,128,0);">.....</SPAN></xsl:when>
															<xsl:when test="@type[.='6dotsEditor']"><SPAN style="color:rgb(255,128,0);">......</SPAN></xsl:when>
															<xsl:when test="@type[.='oSuprae']">&#xF6;</xsl:when>
															<xsl:when test="@type[.='asterisk']">*</xsl:when>
															<xsl:when test="@type[.='undefined']"><SPAN style="color:red"><B>?S?</B></SPAN></xsl:when>
															<xsl:otherwise><SPAN style="color:red"><B>?S?</B></SPAN></xsl:otherwise>
										</xsl:choose>
			</xsl:template>
					
			<xsl:template match="TAB">&#160;&#160;&#160;&#160;</xsl:template>
						
			<xsl:template match="TABLE">
												<TABLE style="border: 1px solid black;"><xsl:apply-templates/></TABLE>
			</xsl:template>
					
			<xsl:template match="TEXT"><xsl:apply-templates/></xsl:template>

			<xsl:template match="TITLE">
					<SPAN style="font-size:14pt;">
												<xsl:choose>
															<xsl:when test="@rend[.='aq']"><SPAN style="background:rgb(224,224,224);"><P><xsl:apply-templates/></P></SPAN></xsl:when>
															<xsl:when test="@rend[.='bl']"><SPAN style="background:rgb(232,255,232);"><P><xsl:apply-templates/></P></SPAN></xsl:when>
															<xsl:otherwise>
																		<P><xsl:apply-templates/></P>
															</xsl:otherwise>												
												</xsl:choose>
						</SPAN>			
			</xsl:template>
			
			<xsl:template match="TITLEPART">
										<xsl:choose>
															<xsl:when test="@type[.='bystmt']"><SPAN style="color:rgb(82,155,51);"><xsl:apply-templates/></SPAN></xsl:when>
															<xsl:when test="@type[.='desc']"><SPAN style="color:rgb(73,84,182);"><xsl:apply-templates/></SPAN></xsl:when>
															<xsl:when test="@type[.='enum']"><SPAN style="color:rgb(215,128,0);"><xsl:apply-templates/></SPAN></xsl:when>
															<xsl:when test="@type[.='main']"><SPAN style="color:rgb(223,0,0);"><xsl:apply-templates/></SPAN></xsl:when>
															<xsl:when test="@type[.='repeated']"><SPAN style="color:rgb(53,13,242);"><xsl:apply-templates/></SPAN></xsl:when>
															<xsl:when test="@type[.='imprint']"><SPAN style="color:rgb(145,145,145);"><xsl:apply-templates/></SPAN></xsl:when>																				
															<xsl:when test="@type[.='dateIssue']"><SPAN style="color:rgb(145,145,145);"><xsl:apply-templates/></SPAN></xsl:when>										
															<xsl:when test="@type[.='dedication']"><SPAN style="color:rgb(145,145,145);"><xsl:apply-templates/></SPAN></xsl:when>										
															<xsl:otherwise><SPAN style="color:rgb(145,145,145);"><xsl:apply-templates/></SPAN></xsl:otherwise>
									</xsl:choose>		
			</xsl:template>
					
			<xsl:template match="TOPONYM"><SPAN style="background:rgb(255,128,255);"><xsl:apply-templates/></SPAN></xsl:template>

			
			<xsl:template match="U"><U><xsl:apply-templates/></U></xsl:template>								
					
</xsl:stylesheet>
