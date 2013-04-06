cube = null
renderer = null
scene = null
camera = null

startTime = new Date().getTime()


init = ->
  scene = new THREE.Scene()

  camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 1, 10000)
  camera.position.set 750, 900, 750
  camera.lookAt(new THREE.Vector3(175, 0, 175))

  gridMaterial = new THREE.MeshBasicMaterial({color: 0x222222, wireframe: true})
  grid = new THREE.Mesh(new THREE.PlaneGeometry(1000, 1000, 15, 15), gridMaterial)
  grid.rotation.x = -Math.PI/2
  scene.add(grid)

  material = new THREE.MeshLambertMaterial({color: 0x0000ff})

  cube = new THREE.Mesh(new THREE.CubeGeometry(66, 66, 66), material)
  cube.position.set(0, 33, 0)
  scene.add(cube)

  directionalLight = new THREE.DirectionalLight(0xffffff, 1)
  directionalLight.position.set(90, 75, 75)
  directionalLight.castShadow = true
  scene.add(directionalLight)

  renderer = new THREE.WebGLRenderer({antialias: true})
  renderer.setSize(window.innerWidth, window.innerHeight)
  renderer.setClearColorHex(0xEEEEEE, 1.0)
  renderer.clear()

  $('body').append(renderer.domElement)


animate = () ->
  requestAnimationFrame(animate)

  t = new Date().getTime() - startTime

  renderer.render(scene, camera)

$(document).ready ->
  init()
  animate()
