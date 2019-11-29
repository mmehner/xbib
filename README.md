# xbib
a shell script that extracts cited Bib(La)TeX entries from a global .bib-file

## Ain't no biber running like sed
Appearently biber get's pretty slow fetching entries from large .bib-files, 
but keeping separate smaller bibliographies for each project is rather tedious.
So this is a quick and dirty fix that will create a local bibliography by extracting only cited entries.

## Usage
1. Change the variable `$bibres` to the path of your global bibliography,
2. make script executable with `chmod +x xbib.sh`,
3. cd into the directory of the master LaTeX-file you want to compile,
4. make sure your .tex-file has exactly one local bibliography specified with `\addbibresource{…}` or `\bibliography{…}`
5. run `/PATH/TO/xbib.sh master.tex`with the master file as first argument, cited entries of master and input-files, 
as well as crossreferences will be written in the file specified,
6. (optional) integrate it into your compilation routine by creating a custom function like 
`xltx () {/PATH/TO/xbib.sh $1 && latexmk $1}`

## Known issues
* Only works if the directory of the master .tex-file is the working directory for script execution, 
but this is easily mitigated by using `pushd` and `popd` in a wrapper function,
* no line except the very last of each entry in the global bibliography is allowed to end in a mere "}" 
as this would lead to the extraction of an incomplete entry at this point.
