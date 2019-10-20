# Text Technologies for Data Science
## Qais Patankar - s1620208

## Installing

You need the `stemming` library installed. Run `pip install stemming`.

If you have `pipenv` installed, you can just use `pipenv install` to install from the given `Pipfile`.

**You must use Python 3.6 or above, like a clean and respectable human that you are.**

## Usage

Here is the output of `python app.py --help`:

```
usage: app.py [-h] [-f QUERIES_FILENAME] [-d PRINT_DOC] [-l LIMIT]
              [-p DECIMAL_PLACES] [-t] [-v] [-r]
              collection_filename [query_str]

positional arguments:
  collection_filename   Filename for the collection
  query_str             Query to use

optional arguments:
  -h, --help            show this help message and exit
  -f QUERIES_FILENAME, --queries-from QUERIES_FILENAME
                        File to read queries from
  -d PRINT_DOC, --print-doc PRINT_DOC
                        Print the document associated with the number and
                        immediately return. Query input is ignored but
                        required
  -l LIMIT, --limit LIMIT
                        Results to return per query. Negative values return
                        all. Default: 1000
  -p DECIMAL_PLACES, --places DECIMAL_PLACES
                        Decimal places to round to for rank output. Negative
                        values don't round. Default: with tfidf, -1, otherwise
                        0
  -t, --tfidf           Enable term weighting (necessary for
                        queries.ranked.txt)
  -v, --debug           Enable debug output
  -r, --refresh         Forcefully refresh the index
```

To produce `results.ranked.txt` from `queries.ranked.txt`, you should do:

```bash
python app.py trec.5000.xml --queries-from queries.ranked.txt --tfidf --places 4 > results.ranked.txt
```

To produce `results.boolean.txt` from `queries.boolean.txt`, you should do:

```bash
python app.py trec.5000.xml --queries-from queries.boolean.txt > results.boolean.txt
```

When you run one of these commands, two index files are created (if the first one does not exist):

- `$collection_filename.index` - a binary file which is loaded for later runs of this tool
- `$collection_filename.index.txt` - a text file representing the binary data (not used by this tool)

Note that when you update this tool or modify `$collection_filename` you should use `--refresh` in
your command to ensure that the index files are updated. Alternatively you can just delete
your `$collection_filename.index` file to force a regeneration.

If you don't do this, the tool may crash or return incorrect results.
