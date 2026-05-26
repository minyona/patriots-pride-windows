<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:s="http://www.sitemaps.org/schemas/sitemap/0.9">
<xsl:template match="/">
<html><head><title>Patriots' Pride Windows — Sitemap</title>
<style>body{font-family:system-ui,sans-serif;max-width:900px;margin:40px auto;padding:0 20px;color:#0a1830}h1{font-size:28px;border-bottom:4px solid #c8222d;padding-bottom:10px}table{width:100%;border-collapse:collapse;margin-top:20px}th{text-align:left;background:#14264c;color:#fff;padding:10px;font-size:13px}td{padding:8px 10px;border-bottom:1px solid #eee;font-size:14px}a{color:#c8222d}</style>
</head><body><h1>Patriots' Pride Windows — XML Sitemap</h1>
<p><xsl:value-of select="count(s:urlset/s:url)"/> URLs</p>
<table><tr><th>URL</th><th>Priority</th><th>Last Modified</th></tr>
<xsl:for-each select="s:urlset/s:url">
<tr><td><a href="{s:loc}"><xsl:value-of select="s:loc"/></a></td><td><xsl:value-of select="s:priority"/></td><td><xsl:value-of select="s:lastmod"/></td></tr>
</xsl:for-each></table></body></html>
</xsl:template></xsl:stylesheet>
