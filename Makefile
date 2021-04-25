run :
		docker-compose up
clean :
		docker-compose rm -f;
		-rm -rf mysql/data/*
