from datetime import datetime
from typing import Literal

from fpdf import FPDF, FontFace, TitleStyle

FONT_FAMILY = "Helvetica"


class PDF(FPDF):
    def __init__(
        self,
        video_id,
        orientation: Literal[
            "", "portrait", "p", "P", "landscape", "l", "L"
        ] = "portrait",
        unit: float | Literal["pt", "mm", "cm", "in"] = "mm",
        format: (
            tuple[float, float]
            | Literal[
                "",
                "a3",
                "A3",
                "a4",
                "A4",
                "a5",
                "A5",
                "letter",
                "Letter",
                "legal",
                "Legal",
            ]
        ) = "A4",
        font_cache_dir: Literal["DEPRECATED"] = "DEPRECATED",
    ) -> None:
        super().__init__(orientation, unit, format, font_cache_dir)
        self.date_created = datetime.now().strftime("Created %Y-%m-%d at %H:%M:%S")
        self.video_id = video_id

    def header(self):
        self.set_text_color(128)
        if self.page_no() > 1:
            self.set_y(10)
            self.set_font(FONT_FAMILY, "I", 8)
            self.cell(0, 0, self.video_id, align="L")
            self.cell(
                0,
                0,
                f"{self.date_created}",
                align="R",
            )
            self.ln(10)

    def footer(self):
        # Setting position at 1.5 cm from bottom:
        self.set_y(-15)
        # Setting font: helvetica italic 8
        self.set_font(FONT_FAMILY, "I", 8)
        # Setting text color to gray:
        self.set_text_color(128)
        # Printing page number
        self.cell(0, 10, f"Page {self.page_no()}", align="C")


def render_toc(pdf, outline):
    pdf.set_x(pdf.epw / 2)
    pdf.set_font(FONT_FAMILY, "B", 15)
    pdf.cell(text="Table of contents", new_x="LMARGIN", new_y="NEXT", align="C")
    pdf.ln(10)
    pdf.set_font()
    # pdf.set_line_width(5)

    for section in outline:
        n_points = int(
            (
                pdf.epw
                - pdf.get_string_width(f"{section.name} page {section.page_number}")
            )
            / pdf.get_string_width(".")
        )
        pdf.cell(
            text=f"{section.name} {n_points*'.'} page {section.page_number}",
            new_x="LMARGIN",
            new_y="NEXT",
            link=pdf.add_link(page=section.page_number),
        )
        pdf.ln(3)


def create_pdf(
    output_path,
    video_id,
    total_comments,
    date_first_comment,
    **chart_paths,
):

    pdf = PDF(video_id=video_id)

    pdf.set_margin(20)
    pdf.set_text_color(80)
    pdf.set_section_title_styles(
        TitleStyle(
            font_size_pt=20,
            b_margin=10,
        )
    )
    pdf.set_font(FONT_FAMILY, size=12)
    # pdf.set_title("YouTube Comment Analysis")
    pdf.add_page()
    pdf.set_font(size=25)
    pdf.cell(
        w=0,
        text="YOUTUBE COMMENT ANALYSIS",
        new_x="LMARGIN",
        new_y="NEXT",
        align="C",
    )
    pdf.ln(5)
    pdf.set_font(size=20)
    pdf.cell(
        w=0,
        text=video_id,
        new_x="LMARGIN",
        new_y="NEXT",
        align="C",
    )

    pdf.set_font(size=11)

    pdf.set_y(pdf.eph / 2)
    pdf.cell(
        w=0,
        text="**Disclosure: Automatically Generated Report**",
        new_x="LMARGIN",
        new_y="NEXT",
        align="C",
        markdown=True,
    )

    pdf.ln(10)

    pdf.multi_cell(
        w=0,
        text="    This report has been automatically generated using data analysis software. It is important to note that the information presented in this report is based on the data available at the time of generation and may be subject to variations or errors. While efforts have been made to ensure the accuracy and consistency of the results, it is recommended to consult other sources and conduct manual verification if necessary."
        "This report is provided for informational purposes only and should not be considered as a sole or definitive source of information. Users are encouraged to exercise their own judgment and due diligence when interpreting the results presented in this report."
        "The author of this report assumes no responsibility for decisions made or actions taken based on the information provided herein. Any use or interpretation of the data presented in this report is solely the responsibility of the user.",
    )

    pdf.add_page()

    pdf.insert_toc_placeholder(render_toc)
    pdf.start_section("I. General")
    with pdf.table(first_row_as_headings=False) as table:
        row = table.row()
        row.cell("Video", style=FontFace(emphasis="B"))
        link = f"https://www.youtube.com/watch?v={video_id}"
        row.cell(str(video_id), link=link)

        row = table.row()
        row.cell("Total Comments", style=FontFace(emphasis="B"))
        row.cell(str(total_comments))

        row = table.row()
        row.cell("Date First Comment", style=FontFace(emphasis="B"))
        date_first_comment = datetime.strptime(date_first_comment, "%Y-%m-%dT%H:%M:%SZ")
        date_first_comment = date_first_comment.strftime("%Y-%m-%d at %H:%M:%S")
        row.cell(str(date_first_comment))

    pdf.ln(10)
    pdf.start_section("II. Sentiment Analysis")

    pdf.cell(
        text="Sentiment analysis of YouTube comments can serve several purposes:",
        new_y="NEXT",
        new_x="LMARGIN",
    )

    pdf.ln(5)

    pdf.cell(text="*")
    pdf.multi_cell(
        w=0,
        text="**Understanding Public Opinion**: It helps understand how viewers perceive a particular video, content creator, or topic. This can be valuable for content creators and businesses looking to ensure that their videos or products are well-received by their target audience.",
        new_y="NEXT",
        new_x="LMARGIN",
        markdown=True,
    )
    pdf.ln(3)

    pdf.cell(text="*")
    pdf.multi_cell(
        w=0,
        text="**Feedback for Content Creators**: Content creators can use sentiment analysis to understand their audience's reactions to their videos. It can help them adjust their content, identify what works well, and what needs improvement.",
        new_y="NEXT",
        new_x="LMARGIN",
        markdown=True,
    )
    pdf.ln(3)

    pdf.cell(text="*")
    pdf.multi_cell(
        w=0,
        text="**Detection of Emotional Trends**: By analyzing sentiments expressed in comments, emotional trends such as anger, joy, sadness, etc., can be spotted. This information can be useful for understanding the emotional impact of a specific video or event.",
        new_y="NEXT",
        new_x="LMARGIN",
        markdown=True,
    )
    pdf.ln(3)

    pdf.cell(text="*")
    pdf.multi_cell(
        w=0,
        text="**Online Reputation Management**: For brands and businesses, sentiment analysis of YouTube comments can help monitor their online reputation. By identifying negative comments or customer concerns, they can intervene quickly to resolve issues and maintain a positive image.",
        new_y="NEXT",
        new_x="LMARGIN",
        markdown=True,
    )
    pdf.ln(3)

    pdf.cell(text="*")
    pdf.multi_cell(
        w=0,
        text="**Influencer Identification**: By analyzing comments, one can identify individuals who have significant influence within a particular community. This can be useful for brands seeking to collaborate with influencers to promote their products or services.",
        new_y="NEXT",
        new_x="LMARGIN",
        markdown=True,
    )

    sentiment_table = [
        ("Positive", "The text expresses an overall positive sentiment."),
        ("Negative", "The text expresses an overall negative sentiment."),
        ("Mixed", "The text expresses both positive and negative sentiments."),
        (
            "Neutral",
            "The text does not express either positive or negative sentiments.",
        ),
    ]

    pdf.ln(10)

    pdf.multi_cell(
        w=0,
        text="The comments are classified into 4 categories described in the table below:",
        new_y="NEXT",
        new_x="LMARGIN",
    )
    pdf.ln(5)

    with pdf.table(first_row_as_headings=False) as table:
        for data_row in sentiment_table:
            row = table.row()
            row.cell(data_row[0], style=FontFace(emphasis="B"))
            for datum in data_row[1:]:
                row.cell(datum, colspan=3)

    pdf.ln(10)

    pdf.set_font(size=15)
    pdf.cell(
        text="A. Overall Sentiment Proportion",
        new_y="NEXT",
        new_x="LMARGIN",
    )
    pdf.set_font(size=11)

    pdf.ln(10)
    pdf.image(chart_paths["chart_sent_percent"], w=pdf.epw)

    pdf.ln(10)

    pdf.set_font(size=15)
    pdf.cell(text="B. Sentiment Proportion by Month", new_y="NEXT", new_x="LMARGIN")
    pdf.set_font(size=11)

    pdf.ln(10)
    pdf.image(chart_paths["chart_sent_timeline"], w=pdf.epw)

    pdf.ln(10)
    pdf.start_section("III. Word Frenquency")

    pdf.ln(10)
    pdf.start_section("IV. Toxicity Analysis")

    pdf.ln(10)
    pdf.start_section("IV. Theme Analysis")

    pdf.output(output_path)

    return output_path
