from flask import Flask, render_template, request
import kubernetes as k8s

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/deploy-workers', methods=['POST'])
def deploy_workers():
    replica_count = int(request.form['replica_count'])
    image_name = 'etc-miner'
    command = '"--farm-recheck", "200", "-G", "-P", "stratum://"' + request.form['wallet_address'] + '"@us1-etc.ethermine.org:4444"'
    deployment_name = request.form['deployment_name']

    deployment = k8s.client.AppsV1Api().create_namespaced_deployment(
        namespace='default',
        body={
            'apiVersion': 'apps/v1',
            'kind': 'Deployment',
            'metadata': {'name': deployment_name},
            'spec': {
                'replicas': replica_count,
                'selector': {'matchLabels': {'app': deployment_name}},
                'template': {
                    'metadata': {'labels': {'app': deployment_name}},
                    'spec': {
                        'containers': [{
                            'name': 'miner',
                            'image': image_name,
                            'command': ['/bin/.ethminer', '-c', command],
                            'ports': [{'containerPort': 8545}],
                        }],
                    },
                },
            },
        },
    )

    return f'Deployment created: {deployment.metadata.name}'

if __name__ == '__main__':
    app.run(debug=True)
