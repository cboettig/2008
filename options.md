---
layout: default
title: Options
subtitle: Chunk options and package options
---

- [Chunk Options](#chunk_options)
- [Package Options](#package_options)

The **knitr** package shares most options with Sweave, but some were dropped/changed and some new options were added. The default values are in the parentheses below. Note that the chunk label for each chunk is assumed to be unique, i.e., no two chunks share the same label. This is especially important for cache and plot filenames. Chunks without labels will be assigned labels like `unnamed-chunk-i` where `i` is the chunk number.

## Chunk Options <a id="chunk_options"></a>

Take Rnw files as an example: usually we write chunk options in the form `tag=value` like this:

{% highlight r %}
<<mychunk, cache=TRUE, eval=FALSE, dpi=100>>=
@
{% endhighlight %}

And `\SweaveOpts{}` can change the default global options in a document (e.g. `\SweaveOpts{comment=NA, fig.width=6, fig.height=6}`). A few special notes on the options:

1. Chunk options must be written in one line, and you should not break them into multiple lines;
1. Avoid spaces ` ` and periods `.` in chunk labels and directory names; if your output is a TeX document, these characters can cause troubles (in general it is recommended to use alphabetic characters with words separated by `-` or `_` and avoid other characters), e.g. `setup-options` is a good label, whereas `setup.options` and `chunk 1` are bad; `fig.path='figures/mcmc-'` is a good prefix for figure output if this project is about MCMC, and `fig.path='markov chain/monte carlo'` is bad;
1. All option values, except the chunk label, must be _valid R expressions_ just like how we write function arguments. For example, options that take _character_ values must be quoted as you do in R (e.g. should write `fig.path="abc"` instead of `fig.path=abc`, and `out.width='\\textwidth'` instead of `out.width=\textwidth`), and for logical options, `TRUE` and `FALSE` are OK, and `true`/`false` will not work as you might have expected; you can write arbitrarily complicated expressions as you want; if you come from the Sweave land, please read the [transition page](/knitr/demo/sweave/) carefully because the syntax is different;

All built-in options in **knitr** are:

### Code Evaluation

- `eval`: (`TRUE`; logical) whether to evaluate the code chunk

### Text Results

- `echo`: (`TRUE`; logical or numeric) whether to include R source code in the output file; besides `TRUE`/`FALSE` which completely turns on/off the source code, we can also use a numeric vector to select which R expression(s) to echo in a chunk, e.g. `echo=2:3` means only echo the 2nd and 3rd expressions, and `echo=-4` means to exclude the 4th expression
- `results`: (`'markup'`; character) takes three possible values
  - `markup`: mark up the results using the output hook, e.g. put results in a special LaTeX environment
  - `asis`: output as-is, i.e., write raw results from R into the output document
  - `hide` hide results; this option only applies to normal R output (not warnings, messages or errors)
  - note `markup` and `asis` are equivalent to `verbatim` and `tex` in Sweave respectively (you can still use the latter two, but they can be misleading, e.g., `verbatim` does not really mean verbatim in R, and `tex` seems to be restricted to LaTeX)
- `warning`: (`TRUE`; logical) whether to show warnings (produced by `warning()`) in the output like we run R code in a terminal
- `error`: (`TRUE`; logical) whether to show errors (from `stop()`) (by default, the evaluation will not stop even in case of errors!!)
- `message`: (`TRUE`; logical) whether to show messages emitted by `message()`
- `split`: (`FALSE`; logical) whether to split the output from R into separate files and include them into LaTeX by `\input{}` or HTML by `<iframe></iframe>`
- `include`: (`TRUE`; logical) whether to include the chunk output in the final output document; if `include=FALSE`, nothing will be written into the output document, but the code is still evaluated and plot files are generated if there are any plots in the chunk, so you can manually insert figures; note this is the only chunk option that is not cached, i.e., changing it will not invalidate the cache

### Code Decoration

- `tidy`: (`TRUE`; logical) whether R code should be tidied up using the function `tidy.source()` in the **formatR** package; if it failed to tidy up, original R code will not be changed; `tidy=TRUE` is like `keep.source=FALSE` in Sweave, but it also tries not to discard R comments (N.B. this option does not work in certain cases; see <https://github.com/yihui/formatR/wiki> for more information)
- `prompt`: (`FALSE`; logical) whether to add the prompt characters in the R code (see `prompt` and `continue` in `?base::options`; note that adding prompts can make it difficult for readers to copy R code from the output, so `prompt=FALSE` may be a better choice
- `comment`: (`'##'`; character) the prefix to be put before source code output; default is to comment out the output by `##`, which is good for readers to copy R source code since output is masked in comments (set `comment=NA` to disable this feature)
- `highlight`: (`TRUE`; character) whether to highlight the source code
- `size`: (`'normalsize'`; character) font size for highlighting some special characters such as the prompts `>` (see `?highlight` in the **highlight** package for details); to change the font size for the whole chunk, you can redefine the `knitrout` environment in the LaTeX preamble (see the chunk hook in the [hooks](/knitr/hooks) page and [an example](/knitr/demo/beamer))
- `background`: (`'#F7F7F7'`; character or numeric) background color of chunks in LaTeX output (passed to the LaTeX package **framed**); the color model is `rgb`; it can be either a numeric vector of length 3, with each element between 0 and 1 to denote red, green and blue, or any built-in color in R like `red` or `springgreen3` (see `colors()` for a full list), or a hex string like `#FFFF00`, or an integer (all these colors will be converted to the RGB model; see `?col2rgb` for details)

### Cache

- `cache`: (`FALSE`; logical) whether to cache a code chunk; when evaluating code chunks, the cached chunks are skipped, but the objects created in these chunks are (lazy-) loaded from previously saved databases (`.rdb` and `.rdx`) files, and these files are saved when a chunk is evaluated for the first time, or when cached files are not found (e.g. you may have removed them by hand); note the filename consists of the chunk label with an MD5 digest of the R code in the chunk (the MD5 string is a summary of the chunk text, and any changes in the chunk will produce a different MD5 digest); unlike the **cacheSweave** package which uses **stashR**, this package directly uses internal functions in base R for cache, and another difference is that results of the code will *still* be included in the output even when cache is used (whereas **cacheSweave** has no output when a chunk is cached), because **knitr** also caches the printed output of a code chunk as a character string
- `cache.path`: (`'cache/'`; character) a prefix to be used for the names of cache files (by default they are saved to a directory named `cache` relative to the current working directory; you can also use an absolute dir here, e.g. `/home/foo/bar-` or `D:\\abc\\mycache`, but it is not recommended since such absolute directories may not exist in other people's systems, therefore it is recommended to use relative directories)
- `dependson`: (`NULL`; character) a character vector of chunk labels to specify which other chunks this chunk depends on; this option applies to cached chunks only -- sometimes the objects in a cached chunk may depend on other cached chunks, so when other chunks are changed, this chunk must be updated accordingly

### Plots

- `fig.path`: (`''`; character) prefix to be used for figure filenames (`fig.path` and chunk labels are concatenated to make filenames); it may contain a directory like `figure/prefix-` (will be created if it does not exist); the default empty string means files will be created under the current working directory
- `fig.keep`: (`'high'`; character) how plots in chunks should be kept; it takes five possible values (see the end of this section for an example)
  - `high`: only keep high-level plots (merge low-level changes into high-level plots);
  - `none`: discard all plots;
  - `all`: keep all plots (low-level plot changes may produce new plots)
  - `first`: only keep the first plot
  - `last`: only keep the last plot
- `fig.show`: (`'asis'`; character) how to show/arrange the plots; three possible values are
  - `asis`: show plots exactly in places where they were generated (as if the code were run in an R terminal);
  - `hold`: hold all plots and output them in the very end of a code chunk;
  - `animate`: wrap all plots into an animation if there are mutiple plots in a chunk;
- `dev`: (`'pdf'`; character) the function name which will be used as a graphical device to record plots; for the convenience of usage, this package has included all the graphics devices in base R as well as those in **Cairo**, **cairoDevice** and **tikzDevice**, e.g. if we set `dev='CairoPDF'`, the function with the same name in the **Cairo** package will be used for graphics output; if none of the 20 built-in devices is appropriate, we can still provide yet another name as long as it is a legal function name which can record plots (it must be of the form `function(filename, width, height)`); note the units for images are *always* inches (even for bitmap devices, in which DPI is used to convert between pixels and inches); currently available devices are `bmp`, `postscript`, `pdf`, `png`, `svg`, `jpeg`, `pictex`, `tiff`, `win.metafile`, `cairo_pdf`, `cairo_ps`, `CairoJPEG`, `CairoPNG`, `CairoPS`, `CairoPDF`, `CairoSVG`, `CairoTIFF`, `Cairo_pdf`, `Cairo_png`, `Cairo_ps`, `Cairo_svg`, `tikz` and a series of `quartz` devices including `quartz_pdf`, `quartz_png`, `quartz_jpeg`, `quartz_tiff`, `quartz_gif`, `quartz_psd`, `quartz_bmp` which are just wrappers to the function `quartz()` with different file types
  - the three options `dev`, `fig.ext` and `dpi` can be vectors (shorter ones will be recycled), e.g. `<<foo, dev=c('pdf', 'png')>>=` creates two files for the same plot: `foo.pdf` and `foo.png`
- `fig.ext`: (`NULL`; character) file extension of the figure output (if `NULL`, it will be derived from the graphical device; see `knitr:::dev2ext` for details)
- `dpi`: (`72`; numeric) the DPI (dots per inch) for bitmap devices (`dpi * inches = pixels`)
- `fig.width`, `fig.height`: (both are `7`; numeric) width and height of the plot, to be used in the graphics device (in inches) and have to be numeric
- `out.width`, `out.height`: (`NULL`; character) width and height of the plot in the final output file (can be different with its real `fig.width` and `fig.height`, i.e. plots can be scaled in the output document); depending on the output format, these two options can take flexible values, e.g. for LaTeX output, they can be `.8\\linewidth`, `3in` or `8cm` and for HTML, they may be `300px` (do not have to be in inches like `fig.width` and `fig.height`; backslashes must be escaped as `\\`)
- `resize.width`, `resize.height`: (`NULL`; character) the width and height to be used in `\resizebox{}{}` in LaTeX; these two options are not needed unless you want to resize tikz graphics because there is no natural way to do it; however, according to **tikzDevice** authors, tikz graphics is not meant to be resized to maintain consistency in style with other texts in LaTeX; if only one of them is `NULL`, `!` will be used (read the documentation of **graphicx** if you do not understand this)
- `fig.align`: (`'default'`; character) alignment of figures in the output document (possible values are `left`, `right` and `center`; default is not to make any alignment adjustments)
- `fig.cap`: (`NULL`; character) figure caption to be used in a figure environment in LaTeX (in `\caption{}`); if `NULL` or `NA`, it will be ignored, otherwise a figure environment will be used for the plots in the chunk (output in `\begin{figure}` and `\end{figure}`)
- `fig.scap`: (`NULL`; character) short caption; if `NULL`, all the words before `.` or `;` or `:` will be used as a short caption; if `NA`, it will be ignored
- `fig.lp`: (`'fig:'`; character) label prefix for the figure label to be used in `\label{}`; the actual label is made by concatenating this prefix and the chunk label, e.g. the figure label for `<<foo-plot>>=` will be `fig:foo-plot` by default
- `fig.pos`: (`''`; character) a character string for the figure position arrangement to be used in `\begin{figure}[fig.pos]`
- `external`: (`TRUE`; logical) whether to externalize tikz graphics (pre-compile tikz graphics to PDF); it is only used for the `tikz()` device in the **tikzDevice** package (i.e., when `dev='tikz'`) and it can save time for LaTeX compilation
- `sanitize`: (`FALSE`; character) whether to sanitize tikz graphics (escape special LaTeX characters); see documentation in the **tikzDevice** package

Note any number of plots can be recorded in a single code chunk, and this package does not need to know how many plots are in a chunk in advance -- it can figure out automatically, and name these images as `fig.path-label-i` where `i` is incremental from 1; if a code chunk does not actually produce any plots, **knitr** will not record anything either (the graphics device is open *only when plots are really produced*); in other words, it does not matter if `fig.keep='high'` but no plots were produced.

Low-level plotting commands include `lines()` and `points()`, etc. To better understand `fig.keep`, consider the following chunk:

{% highlight r %}
<<test-plot>>=
plot(1)         # high-level plot
abline(0, 1)    # low-level change
plot(rnorm(10)) # high-level plot
## many low-level changes in a loop (a single R expression)
for(i in 1:10) {
    abline(v = i, lty = 2)
}
@
{% endhighlight %}

Normally this produces 2 plots in the output (i.e. when `fig.keep='high'`); for `fig.keep='none'`, no plots will be saved; for `fig.keep='all'`, 4 plots are saved; for `fig.keep='first'`, the plot produced by `plot(1)` is saved, and for `fig.keep='last'`, the last plot with 10 vertical lines is saved.

There are two hidden options which are not designed to be set by the users: `fig.cur` (the current figure number or index when there are multiple figures) and `fig.num` (the total number of figures in a chunk). The purpose of these two options is to help **knitr** deal with the filenames of multiple figures as well as animations. In some cases, we can make use of them to write animations into the output using plot files which are saved manually (see the [graphics manual](https://github.com/downloads/yihui/knitr/knitr-graphics.pdf) for examples).

### Animation

- `interval`: (`1`; numeric) number of seconds to pause between animation frames
- `aniopts`: (`'controls,loop'`) extra options for animations; see the documentation of the [animate package](http://www.ctan.org/tex-archive/macros/latex/contrib/animate)

### Chunk Reference

- `ref.label`: (`NULL`; character) a character vector of labels of the chunks from which R code is borrowed (see the demo for [chunk reference](/knitr/demo/reference/))

### Child Documents

- `child`: (`NULL`; character) a character vector of filenames of child documents to be run and input into the main document

## Package Options <a id="package_options"></a>

The package options can be changed using the object [`opts_knit`](objects); for example,

{% highlight r %}
opts_knit$set(progress = TRUE, verbose = TRUE)
{% endhighlight %}

All package options are:

- `progress`: (`TRUE`) whether to display a progress bar when running **knitr**
- `verbose`: (`FALSE`) whether to show verbose information (e.g., R code in each chunk) or just show chunk labels and options
- `out.format`: (`NULL`) possible values are `latex`, `sweave`, `html`, `markdown`, `gfm` and `jekyll`; it will be automatically determined based on the input file, and this option will affect which set of hooks to use (see `?render_latex` for example); note this option has to be set _before_ `knit()` runs (i.e. it does not work if you set it in the document), or alternatively, you can use the `render_*` series inside the document to set up the hooks
- `child.command`: (`'input'`) the LaTeX command to be used to insert child documents into the main document (usually `input` or `include`)
- `child.path`: (`''`) the search path for child documents; by default child documents are searched for relative to the directory of the parent document
- `all.patterns`: a list of built-in patterns
- `header`: the text to be inserted into the output document before the document begins (e.g. after `\documentclass{article}` in LaTeX, or `<head>` in HTML); this is useful for defining commands and styles in the LaTeX preamble or HTML header; the beginning of document is found using the pattern defined in `knit_patternss$get('document.begin')`
- `base.dir`: (`NULL`) an absolute directory under which the plots are generated
- `base.url`: (`NULL`) the base url for HTML pages
- `eval.after`: (`NULL`) a character vector of option names; these options will be evaluated _after_ a chunk is evaluated, and all other options will be evaluated before a chunk (e.g. for chunk option `fig.cap=paste('p-value is', t.test(x)$p.value)`, it will be evaluated after the chunk according to the value of `x` if `eval.after='fig.cap'`)
- `upload.fun`: (`identity`) a function that takes a filename as its input, processes it and returns a character string when the output format is HTML or Markdown; typically it is a function to upload a image and return the link to the image, e.g. `opts_knit$set(upload.fun = imgur_upload)` can upload a file to <http://imgur.com> (see `?imgur_upload`)
- `cache.extra`: (`NULL`) extra content that should affect [cache](/knitr/demo/cache)
- `aliases`: (`NULL`) a named character vector to specify the aliases of chunk options, e.g. `c(h = 'fig.height', w = 'fig.width')` tells **knitr** that the chunk option `h` really means `fig.height`, and `w` is an alias for `fig.width`; this option can be used to save some typing efforts for long option names
- `concordance`: (`FALSE`) whether to write a concordance file to map the output line numbers to the input line numbers; this enables one to navigate from the output to the input and can be helpful especially when TeX error occurs (this feature is mainly for RStudio)

