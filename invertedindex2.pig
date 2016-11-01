/* 

# a pig program to read data from files and create an inverted index for all words in the files.  
# Author:   Shahram Mohrehkesh (smohr003@odu.edu)
# Created:  01/17/2014
#
# Copyright (C) 2014 
# For license information, see LICENSE.txt
#

*/


-- 
-- load 
t1 = LOAD 'texts/file1.txt' USING TextLoader() AS (string:chararray);
t1 = FOREACH t1 GENERATE 'file1.txt' as fname, string;
t2 = LOAD 'texts/file2.txt' USING TextLoader() as (string:chararray);
t2 = FOREACH t2 GENERATE 'file2.txt' as fname, string;
text = UNION t1, t2;
-- produce words 
words = FOREACH text GENERATE fname, FLATTEN( TOKENIZE(string) );
-- produce the index 
word_groups = GROUP words BY $1;
index = FOREACH word_groups {
files = DISTINCT $1.$0;
cnt = COUNT(files);
GENERATE $0, cnt, files;
};
-- store the result. 
STORE index INTO '/data/inverted_index';
