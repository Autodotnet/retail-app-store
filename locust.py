from locust import HttpUser, task, between

 

class WebsiteUser(HttpUser):
    wait_time = between(1, 2.5)

    @task
    def load_test(self):
        self.client.get("/")

        # locust -f locust.py --headless -u 100 -r 10 --host=http://34.70.53.157/ -t 70