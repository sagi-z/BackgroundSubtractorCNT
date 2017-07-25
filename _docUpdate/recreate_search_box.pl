#!/usr/bin/perl

print "Will create file '$ARGV[1]' from '$ARGV[0]'\n";

open IN, $ARGV[0];
open OUT, "> $ARGV[1]";
while (<IN>) {
    if (! $done) {
        if ($shouldPrint) {
            print OUT <<EOF;
  <div class="doxygen-search-container">
        <div id="MSearchBox" class="MSearchBoxInactive" style="z-index:auto; right:auto; left:0">
        <span class="left">
          <img id="MSearchSelect" src="search/mag_sel.png"
               onmouseover="return searchBox.OnSearchSelectShow()"
               onmouseout="return searchBox.OnSearchSelectHide()"
               alt=""/>
          <input type="text" id="MSearchField" value="Search" accesskey="S"
               onfocus="searchBox.OnSearchFieldFocus(true)" 
               onblur="searchBox.OnSearchFieldFocus(false)" 
               onkeyup="searchBox.OnSearchFieldChange(event)"/>
          </span><span class="right">
            <a id="MSearchClose" href="javascript:searchBox.CloseResultsWindow()"><img id="MSearchCloseImg" border="0" src="search/close.png" alt=""/></a>
          </span>
        </div>
  </div>

        <!-- window showing the filter options -->
        <div id="MSearchSelectWindow"
             onmouseover="return searchBox.OnSearchSelectShow()"
             onmouseout="return searchBox.OnSearchSelectHide()"
             onkeydown="return searchBox.OnSearchSelectKey(event)">
        </div>

        <!-- iframe showing the search results (closed by default) -->
  <div class="doxygen-search-results-container">
        <div id="MSearchResultsWindow">
        <iframe src="javascript:void(0)" frameborder="0" 
                name="MSearchResults" id="MSearchResults">
        </iframe>
        </div>
  </div>

EOF
            $done = 1;
        } elsif ($foundNew) {
            $shouldPrint=1 if /<\/script>/;
        } else {
            $foundNew=1 if /new SearchBox\(/;
        }
    }
    print OUT;
}
close OUT;
close IN;
