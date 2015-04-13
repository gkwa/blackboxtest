blackbox:
	git clone 'https://github.com/StackExchange/blackbox'

test: blackbox
	sh -x test.sh


clean:
	rm -f foo.pub
	rm -f foo.sec
	rm -f foo