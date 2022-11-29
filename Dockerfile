FROM pyodide/pyodide-env:20220525-py310-chrome102-firefox100 as base
WORKDIR /app

COPY package*.json .
RUN npm ci --only=production

COPY n.js .
COPY pyodide pyodide/

FROM base as test
# build with `docker build --target test .` to run this test locally

COPY test.sh /app/test.sh
RUN /app/test.sh

FROM base

ENTRYPOINT ["node", "n.js"]
