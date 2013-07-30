describe "Core Ruby Extensions" do

	it "should drop elements from the end of the array" do
		a = %w{1, 2, 3, 4, 5, 6, 7}
		a.drop(1).should == %w{2, 3, 4, 5, 6, 7}
		a.drop(2).should == %w{3, 4, 5, 6, 7}
		a.drop(3).should == %w{4, 5, 6, 7}
	end

	it "should title case words" do
		"the quick brown dog jumped over the lazy fox".titlecase.should == "The Quick Brown Dog Jumped Over The Lazy Fox"
		"THIS IS ALL CAPS".titlecase.should == "This Is All Caps"
	end

end
