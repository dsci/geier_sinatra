module LastResponseSamples

  shared_examples_for "last response status" do
    it "is ok" do
      last_response.should be_ok
    end
  end

  shared_examples_for "correct content type" do

    it "is json" do
      last_response.headers["Content-Type"].should == "application/json"
    end
  end

end