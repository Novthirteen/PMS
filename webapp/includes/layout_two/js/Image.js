function changeImageSrc(loc,src) {
  if (document.images)
    document.images[loc].src=src;
}
 
function adjustImages() {
  for (var i=0; i<document.images.length; i++) {
    // Hide empty outline images
    if ((document.images[i].src.substring(document.images[i].src.length-18,document.images[i].src.length)=='/icons/ecblank.gif') && (document.images[i].width==20)) {
       document.images[i].width=0;
       document.images[i].height=0;
    } else
    // Switch twisties
    if (document.images[i].src.substring(document.images[i].src.length-19,document.images[i].src.length)=='/icons/collapse.gif') {
      document.images[i].src=webGraphicsPath+'syswc/$file/collapse.gif';
    } else
    if (document.images[i].src.substring(document.images[i].src.length-17,document.images[i].src.length)=='/icons/expand.gif') {
      document.images[i].src=webGraphicsPath+'syswc/$file/expand.gif';
    }
  } 
}