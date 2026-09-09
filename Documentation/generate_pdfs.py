from pathlib import Path
from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER
from reportlab.lib.pagesizes import A4, landscape
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import mm
from reportlab.pdfgen import canvas
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, PageBreak


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "output" / "pdf"
OUTPUT.mkdir(parents=True, exist_ok=True)


def draw_box(c, x, y, width, height, title, lines, fill):
    c.setFillColor(fill)
    c.setStrokeColor(colors.HexColor("#3D5A40"))
    c.roundRect(x, y, width, height, 4 * mm, fill=1, stroke=1)
    c.setFillColor(colors.HexColor("#183A1D"))
    c.setFont("Helvetica-Bold", 12)
    c.drawCentredString(x + width / 2, y + height - 8 * mm, title)
    c.setFont("Helvetica", 9)
    line_y = y + height - 15 * mm
    for line in lines:
        c.drawCentredString(x + width / 2, line_y, line)
        line_y -= 5 * mm


def arrow(c, x1, y1, x2, y2, label=None):
    c.setStrokeColor(colors.HexColor("#526052"))
    c.setFillColor(colors.HexColor("#526052"))
    c.setLineWidth(1.4)
    c.line(x1, y1, x2, y2)
    angle = 3 * mm
    if x1 == x2:
        c.line(x2, y2, x2 - angle, y2 + angle)
        c.line(x2, y2, x2 + angle, y2 + angle)
    else:
        c.line(x2, y2, x2 - angle, y2 + angle)
        c.line(x2, y2, x2 - angle, y2 - angle)
    if label:
        c.setFont("Helvetica", 8)
        c.drawCentredString((x1 + x2) / 2, (y1 + y2) / 2 + 2 * mm, label)


def make_architecture_pdf():
    path = OUTPUT / "SoloPlate_Human_System_Architecture.pdf"
    page_width, page_height = landscape(A4)
    c = canvas.Canvas(str(path), pagesize=(page_width, page_height))

    c.setFillColor(colors.HexColor("#FAF8F0"))
    c.rect(0, 0, page_width, page_height, fill=1, stroke=0)
    c.setFillColor(colors.HexColor("#183A1D"))
    c.setFont("Helvetica-Bold", 22)
    c.drawString(18 * mm, page_height - 18 * mm, "SoloPlate Human-System Architecture")
    c.setFont("Helvetica", 10)
    c.drawString(18 * mm, page_height - 25 * mm, "Primary flow: use recorded fridge food to choose and complete one quick meal")

    human_x = 14 * mm
    system_x = 79 * mm
    box_w = 57 * mm
    system_w = 70 * mm
    data_x = 234 * mm
    box_h = 31 * mm
    top_y = page_height - 68 * mm

    c.setFillColor(colors.HexColor("#8A5A24"))
    c.setFont("Helvetica-Bold", 11)
    c.drawString(human_x, page_height - 38 * mm, "HUMAN")
    c.drawString(system_x, page_height - 38 * mm, "SOLOPLATE APP")
    c.drawString(data_x, page_height - 38 * mm, "LOCAL DATA")

    c.setStrokeColor(colors.HexColor("#C9B99A"))
    c.setDash(5, 3)
    c.line(72 * mm, 19 * mm, 72 * mm, page_height - 42 * mm)
    c.setDash()
    c.setFont("Helvetica", 8)
    c.setFillColor(colors.HexColor("#7A6A52"))
    c.drawCentredString(72 * mm, 13 * mm, "human-system boundary")

    draw_box(c, human_x, top_y, box_w, box_h, "Person cooking for one", ["1. Checks and enters food", "6. Reads result or error", "Confirms meal after cooking"], colors.HexColor("#F7DFC1"))
    draw_box(c, system_x, top_y, system_w, box_h, "SwiftUI Views", ["1. Receive user action", "My Fridge and Tonight's Picks", "6. Show result and next step"], colors.HexColor("#DDEEDB"))
    draw_box(c, system_x, top_y - 40 * mm, system_w, box_h, "SoloPlateViewModel", ["2. Starts business operation", "Holds screen state", "5. Receives result or error"], colors.HexColor("#E7F3E5"))
    draw_box(c, system_x, top_y - 80 * mm, system_w, box_h, "Use Cases", ["3. Apply meal rules", "Register and recommend", "Record prepared meal"], colors.HexColor("#CDE5CC"))
    draw_box(c, system_x, top_y - 120 * mm, system_w, box_h, "Domain models and repositories", ["FridgeItem and Recipe", "MealSuggestion", "Business errors and rules"], colors.HexColor("#BFD9BD"))
    draw_box(c, data_x, top_y - 80 * mm, box_w, box_h, "Local data", ["4. Read or update", "In-memory fridge and recipes.json", "No account or internet"], colors.HexColor("#E8E2D2"))

    arrow(c, human_x + box_w, top_y + box_h / 2 + 5 * mm, system_x, top_y + box_h / 2 + 5 * mm)
    arrow(c, system_x, top_y + box_h / 2 - 5 * mm, human_x + box_w, top_y + box_h / 2 - 5 * mm)
    arrow(c, system_x + system_w / 2, top_y, system_x + system_w / 2, top_y - 9 * mm)
    arrow(c, system_x + system_w / 2, top_y - 40 * mm, system_x + system_w / 2, top_y - 49 * mm)
    arrow(c, system_x + system_w / 2, top_y - 80 * mm, system_x + system_w / 2, top_y - 89 * mm)
    arrow(c, system_x + system_w, top_y - 65 * mm, data_x, top_y - 65 * mm, "read or update")

    c.setFont("Helvetica-Oblique", 8)
    c.setFillColor(colors.HexColor("#6B6B60"))
    c.drawRightString(page_width - 14 * mm, 10 * mm, "The user checks the real food. SoloPlate does not decide food safety.")
    c.save()


def make_reflection_pdf():
    source = ROOT / "Documentation" / "Reflection_Draft.md"
    output = OUTPUT / "SoloPlate_Reflective_Report.pdf"
    styles = getSampleStyleSheet()
    styles.add(ParagraphStyle(name="ReportTitle", parent=styles["Title"], fontName="Helvetica-Bold", fontSize=19, leading=23, textColor=colors.HexColor("#183A1D"), alignment=TA_CENTER, spaceAfter=14))
    styles.add(ParagraphStyle(name="ReportHeading", parent=styles["Heading2"], fontName="Helvetica-Bold", fontSize=13, leading=16, textColor=colors.HexColor("#315B35"), spaceBefore=9, spaceAfter=5))
    styles.add(ParagraphStyle(name="ReportBody", parent=styles["BodyText"], fontName="Helvetica", fontSize=10.5, leading=15, spaceAfter=8))

    story = []
    for block in source.read_text().strip().split("\n\n"):
        if block.startswith("# "):
            story.append(Paragraph(block[2:], styles["ReportTitle"]))
        elif block == "## Human-system design":
            story.append(PageBreak())
            story.append(Paragraph(block[3:], styles["ReportHeading"]))
        elif block.startswith("## "):
            story.append(Paragraph(block[3:], styles["ReportHeading"]))
        else:
            story.append(Paragraph(block.replace("`", ""), styles["ReportBody"]))

    def footer(c, doc):
        c.saveState()
        c.setFont("Helvetica", 8)
        c.setFillColor(colors.HexColor("#777777"))
        c.drawString(18 * mm, 11 * mm, "SoloPlate Assessment 2 - Reflective Report Draft")
        c.drawRightString(A4[0] - 18 * mm, 11 * mm, f"Page {doc.page}")
        c.restoreState()

    doc = SimpleDocTemplate(
        str(output),
        pagesize=A4,
        rightMargin=20 * mm,
        leftMargin=20 * mm,
        topMargin=18 * mm,
        bottomMargin=19 * mm,
        title="SoloPlate Reflective Report",
        author="Haoming Chen",
    )
    doc.build(story, onFirstPage=footer, onLaterPages=footer)


if __name__ == "__main__":
    make_architecture_pdf()
    make_reflection_pdf()
    print("Created two PDF drafts in output/pdf")
