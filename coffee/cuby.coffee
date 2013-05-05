cube = null
renderer = null
scene = null
camera = null

gridCount = 13
cubeSize = 100
cubeAnimationDuration = 200


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
  cube.moving = false
  cube.gridPosition = new GridPosition 0, 0
  cube.position = cube.gridPosition.toVector3()
  cube.targetPosition = new GridPosition 0, 0
  scene.add(cube)

  evilCube = new THREE.Mesh(new THREE.CubeGeometry(cubeSize, cubeSize, cubeSize), new THREE.MeshLambertMaterial({color: 0xff0000}))
  evilCube.gridPosition = new GridPosition 2, 0
  evilCube.position = evilCube.gridPosition.toVector3()
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

lastTime = new Date().getTime()
animationTime = 0

animate = () ->
  requestAnimationFrame(animate)

  dt = new Date().getTime() - lastTime
  lastTime = new Date().getTime()

  controls.update()

  if cube.targetPosition.x != cube.gridPosition.x || cube.targetPosition.z != cube.gridPosition.z
    if animationTime < cubeAnimationDuration
      cube.moving = true

      targetPosition = cube.targetPosition.toVector3()

      progressTime = animationTime / cubeAnimationDuration

      deltaPosition = cube.targetPosition.toVector3().sub(cube.gridPosition.toVector3())

      cube.position = cube.gridPosition.toVector3().add(deltaPosition.multiplyScalar(progressTime))

      animationTime += dt
    else
      cube.moving = false
      cube.position = cube.targetPosition.toVector3()
      cube.gridPosition = cube.targetPosition.clone()
      animationTime = 0


  renderer.render(scene, camera)


controls =
  status:
    back: false
    forward: false
    right: false
    left: false
  onKeydown: (event) ->
    switch event.keyCode
      when 87 then do () ->
        controls.status.back = true
      when 83 then do () ->
        controls.status.forward = true
      when 68 then do () ->
        controls.status.right = true
      when 65 then do () ->
        controls.status.left = true
    console.log controls.status
  onKeyup: (event) ->
    switch event.keyCode
      when 87 then do () ->
        controls.status.back = false
      when 83 then do () ->
        controls.status.forward = false
      when 68 then do () ->
        controls.status.right = false
      when 65 then do () ->
        controls.status.left = false
  update: ->
    if not cube.moving
      if this.status.back
        cube.targetPosition.x -= 1
      else if this.status.forward
        cube.targetPosition.x += 1
      else if this.status.right
        cube.targetPosition.z -= 1
      else if this.status.left
        cube.targetPosition.z += 1


$(document).ready ->
  init()

  document.addEventListener('keydown', controls.onKeydown, false)
  document.addEventListener('keyup', controls.onKeyup, false)

  animate()
