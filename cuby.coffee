cube = null
renderer = null
scene = null
camera = null

gridCount = 13
cubeSize = 100

startTime = new Date().getTime()


class GridPosition
  constructor: (@x, @z) ->

  move: (dx, dz) ->
    @x += dx
    @z += dz

  clone: () ->
    return new GridPosition(@x, @z)

  fromVector3: (vector) ->
    @x = vector.x/cubeSize
    @z = vector.z/cubeSize

  toVector3: () ->
    new THREE.Vector3(@x*cubeSize, cubeSize/2, @z*cubeSize)


getGridPosition = (vector) ->
  return {x: vector.x/cubeSize, y: 0, z: vector.z/cubeSize}

calcGridPosition = (x, z) ->
  new THREE.Vector3(x*cubeSize, cubeSize/2, z*cubeSize)

init = ->
  scene = new THREE.Scene()

  camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 1, 10000)
  camera.position.set 1000, 1400, 1000
  camera.lookAt(new THREE.Vector3(175, 0, 175))

  gridMaterial = new THREE.MeshBasicMaterial({color: 0x222222, wireframe: true})
  grid = new THREE.Mesh(new THREE.PlaneGeometry(100*gridCount, 100*gridCount, gridCount, gridCount), gridMaterial)
  grid.rotation.x = -Math.PI/2
  scene.add(grid)

  material = new THREE.MeshLambertMaterial({color: 0x0000ff})

  cube = new THREE.Mesh(new THREE.CubeGeometry(cubeSize, cubeSize, cubeSize), material)
  cube.position = calcGridPosition 0, 0
  cube.gridPosition = new GridPosition 0, 0
  cube.targetPosition = new GridPosition 0, 0
  scene.add(cube)

  evilCube = new THREE.Mesh(new THREE.CubeGeometry(cubeSize, cubeSize, cubeSize), new THREE.MeshLambertMaterial({color: 0xff0000}))
  evilCube.position = gridPosition 2, 0
  scene.add(evilCube)

  directionalLight = new THREE.DirectionalLight(0xffffff, 1)
  directionalLight.position.set(90, 75, 75)
  directionalLight.castShadow = true
  scene.add(directionalLight)

  renderer = new THREE.WebGLRenderer({antialias: true})
  renderer.setSize(window.innerWidth, window.innerHeight)
  renderer.setClearColorHex(0xeeeeee, 1.0)
  renderer.clear()

  $('body').append(renderer.domElement)


animate = () ->
  requestAnimationFrame(animate)

  t = new Date().getTime() - startTime

  if cube.targetPosition.x != cube.gridPosition.x || cube.targetPosition.z != cube.gridPosition.z
    cube.position = cube.targetPosition.toVector3()
    cube.gridPosition = cube.targetPosition.clone()

  renderer.render(scene, camera)


onKeydown = (event) ->
  switch event.keyCode
    when 87 then do () ->
      cube.targetPosition.x -= 1
    when 83 then do () ->
      cube.targetPosition.x += 1
    when 68 then do () ->
      cube.targetPosition.z -= 1
    when 65 then do () ->
      cube.targetPosition.z += 1
    else
      console.log event.keyCode


$(document).ready ->
  init()

  document.addEventListener('keydown', onKeydown, false)

  animate()
