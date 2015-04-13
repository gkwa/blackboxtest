test2: blackbox
	sh -x test2.sh

blackbox:
	git clone 'https://github.com/StackExchange/blackbox'

clean:
	rm -f foo.pub
	rm -f foo.sec
	rm -f foo
	rm -rf .gnupg
	rm -rf repo
