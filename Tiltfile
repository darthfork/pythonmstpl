allow_k8s_contexts('kind-control-plane')

docker_build('pythonmstpl:tilt', '.')

yaml = helm(
  'helm',
  name='pythonmstpl',
  namespace='default',
  values=['./helm/values.yaml'],
  set = ["image.tag=tilt"]
  )

k8s_yaml(yaml)

k8s_resource(workload='pythonmstpl', port_forwards=['5000'])
