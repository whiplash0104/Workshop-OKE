FROM nginx:1.10.1-alpine

Add index.html /usr/share/nginx/html/index.html

COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
