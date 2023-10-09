import json
import os
import pytest

import pyarrow.flight as fl
import pandas as pd

MASKED_DATA_ENTRY = 'XXXXX'

@pytest.fixture
def get_data():
    # Create a Flight client
    client = fl.connect(os.getenv('ENDPOINT_URL'))

    # Prepare the request
    request = {
        "asset": f"{os.getenv('CATALOGED_ASSET')}",
        # To request specific columns add to the request a "columns" key with a list of column names
        # "columns": []
    }

    # Send request and fetch result as a pandas DataFrame
    info = client.get_flight_info(fl.FlightDescriptor.for_command(json.dumps(request)))
    reader: fl.FlightStreamReader = client.do_get(info.endpoints[0].ticket)
    df: pd.DataFrame = reader.read_pandas()

    return df

class TestFybrik:

    def test_should_return_data_frame_with_specific_columns_containing_masked_data(self, get_data):
        data = get_data

        assert all(val == MASKED_DATA_ENTRY for val in data['nameOrig'])
        assert all(val == MASKED_DATA_ENTRY for val in data['oldbalanceOrg'])
        assert all(val == MASKED_DATA_ENTRY for val in data['newbalanceOrig'])

    def test_should_return_data_frame_with_specific_columns_not_containing_masked_data(self, get_data):
        data = get_data

        assert all(val != MASKED_DATA_ENTRY for val in data['amount'])
        assert all(val != MASKED_DATA_ENTRY for val in data['newbalanceDest'])
        assert all(val != MASKED_DATA_ENTRY for val in data['type'])