
# "http://52.16.7.112:8000"
combo = new Combo("http://52.16.7.112:8000")

arenaSource = "validPlayerCoordinates"
scoreSource = "LeaderBoard"

combo.use [arenaSource, scoreSource, "ArenaClock"]


clockElem = document.getElementById("clock")
combo.listen "ArenaClock", (data) ->
	clockElem.replaceChild(document.createTextNode(data.tick), clockElem.firstChild)


boardSize = [20, 20]
cellSize = 20
rightMargin = 200
legendPos = [boardSize.0*cellSize + 40, 20]

arenaElem = document.getElementById("arena")
paper = Raphael(400, 100, boardSize.0*cellSize+1 + rightMargin, boardSize.1*cellSize+1)
paper.setViewBox(-0.5, -0.5, boardSize.0*cellSize+1 + rightMargin, boardSize.1*cellSize+1)

currentData = {
	"positions": []
}
currentScores = {}

drawLine = (x0, y0, x1, y1) ->
	paper.path("M" + x0 + " " + y0 + "L" + x1 + " " + y1)

robotColors =
	'#f00'
	'#0f0'
	'#00f'
	'#f0f'
	'#0ff'
	'#f0f'

nextColor = 0
idsToColor = {}

getRobotColor = (id) ->
	unless id of idsToColor
		idsToColor[id] = robotColors[nextColor++ % *]
	idsToColor[id]

update = ->
	data = currentData
	arenaElem.textContent = JSON.stringify(data, null, "  ")

	paper.clear()
	paper.renderfix()
	paper.rect(0, 0, boardSize.0*cellSize, boardSize.1*cellSize).attr("fill", '#eee')

	for x to boardSize.0
		drawLine(x*cellSize, 0, x*cellSize, boardSize.1*cellSize).attr({"stroke": '#000'})
	for y to boardSize.1
		drawLine(0, y*cellSize, boardSize.0*cellSize, y*cellSize)

	for robot, index in data.positions
		pos = robot.coordinates
		console.log pos
		color = getRobotColor(robot.id)
		score = currentScores[robot.id] || 0
		paper.rect(pos.0*cellSize, pos.1*cellSize, cellSize, cellSize).attr("fill", color)
		paper.rect(legendPos.0, index*2*cellSize, cellSize, cellSize).attr("fill", color)
		paper.text(legendPos.0 + 1.5*cellSize, (index*2+0.5)*cellSize, robot.id + "    (#score)").attr({"font-size": "16px", "text-anchor": "start"})

combo.listen arenaSource, (data) ->
	currentData := data
	update()

combo.listen scoreSource, (scores) ->
	console.dir scores
	currentScores := scores.scores
	update()

update()
