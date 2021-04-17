#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Author: Arne Neumann <nlpbox.programming@arne.cl>

"""This is a simple black-box test for the CoreNLP REST API."""

from __future__ import print_function
import pexpect
import pytest
import requests

EXPECTED_PARSE =  "(ROOT\n  (S\n    (SBAR (IN Although)\n      (S\n        (NP (PRP they))\n        (VP (VBD did) (RB n't)\n          (VP (VB like)\n            (NP (PRP it))))))\n    (, ,)\n    (NP (PRP they))\n    (VP (VBD accepted)\n      (NP (DT the) (NN offer)))\n    (. .)))"


@pytest.fixture(scope="session", autouse=True)
def start_api():
    """Starts the CoreNLP REST API in a separate process."""
    print("starting API...")
    # 2 GB RAM seems to be the minimal amount CoreNLP needs to parse
    # the example sentence.
    child = pexpect.spawn('java -Xmx2g -cp "*" edu.stanford.nlp.pipeline.StanfordCoreNLPServer -port 9000 -timeout 15000')
    yield child.expect('(?i)StanfordCoreNLPServer listening at /0.0.0.0:9000') # provide the fixture value
    print("stopping API...")
    child.close()


def test_api_short():
    """The CoreNLP API produces the expected parse output."""
    input_text = "Although they didn't like it, they accepted the offer."
    res = requests.post(
        'http://localhost:9000/?properties={"annotators":"parse","outputFormat":"json"}',
        data=bytes(input_text, 'utf-8'))
    json_result = res.json()
    assert json_result['sentences'][0]['parse'] == EXPECTED_PARSE
