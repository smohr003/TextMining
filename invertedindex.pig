/* 

# a pig program to read data from files and create an inverted index for all words in the files.  
# Author:   Shahram Mohrehkesh (smohr003@odu.edu)
# Created:  01/17/2014
#
# Copyright (C) 2014 
# For license information, see LICENSE.txt
#

*/

/* Build an inverted index.
 * 
 * An inverted index maps words to the documents
 * they appear in.
 * 
 * Run this in local mode with:
 *   pig -x local inverted-index.pig
 */

content = LOAD './input' AS (line_id:int, text:chararray);

words = FOREACH content GENERATE line_id, FLATTEN(TOKENIZE(text)) AS word;
word_groups = GROUP words BY word;
inverted_index = FOREACH word_groups GENERATE group AS word, words.line_id;

STORE inverted_index INTO './output';
