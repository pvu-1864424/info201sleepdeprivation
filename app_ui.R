library(shiny)
library(shinythemes)
library(plotly)
source("analysis.R")

ui <- fluidPage(
  navbarPage(
    theme = shinytheme("slate"),
    "Sleep Deprivation",
    tabPanel(
      "Background",
      tags$div(
        h3("About This Project:"),
        p("In today's society, people sacrifice their sleep time for various
          reasons: studying for exams, finishing up work or tasks, suffering
          from anxiety or sleep disorders… etc. No matter what the reasons are,
          they all contribute to sleep deprivation. Since people not getting
          enough sleep has become a global phenomenon, it is important to learn
          about its effect and what sleep deprivation is like in society."),
        p("This project specifically focuses on the topic of sleep deprivation
          for adults aged 19 to 39 in the United States. The topics covered in
          this project include adults' sleeping trends from 2000 to 2015,
          negative impacts of sleep deprivation, the general sleeping hour in
          each state, and how much time people spend on different activities
          compared to their sleep time. Moreover, by presenting the information
          through different types of interactive and non-interactive graphs,
          our team hopes to provide a fun and interactive learning experience
          to the users."),
        h3("Page Description"),
        p("The Trend tab introduces the average sleep time for U.S adult aged
          19 to 39 from 2000 to 2012, the information was collected by applying
          Actigraphic Study and Polysomnography Study. On the bottom, a map
          illustrates the average percentage of people who do not have a least
          7 hours of sleep in each state in the U.S."),
        p("The Brutal Reality tab shows the fact that our performance is bad
          because of sleep deprivation. "),
        p("The Causes tab has two sub tabs. On the Multiple Factors tab, an
          interactive pie chart demonstrates the most common factors that
          cause U.S college students stay up so late at night based on the
          survey. On the Life tracking sample page, the interactive scatter
          plot compares different activity time with people’s sleep time."),
        p("The Impact tab introduces some possible impact on people’s mental
          and physical health if people are sleep deprived for long, as well
          as how sleep deprivation could affect students’ academic performance.
          The tab has an interactive scatterplot that allows user to choose
          their own interest of age group and multiple outcomes of sleep
          deprivation. On the bottom, an interactive bar graph gives users a
          glance of  U.S college students’ average GPA affected by daytime
          sleepiness."),
        p("The conclusion tab summarize the biggest lesson of this project,
          strength and weakness, and some possible improvement that could
          be made to make this project better. The sleep time calculator at the
          bottom will calculate the time user should go to bed to get enough
          sleep based on their age and what time they plan to wake up."),
        p("The About tab has two sub tabs : About Tech and About us. The About
          Tech tab has the citation for all the resources used in the project.
          The About Us tab gives a brief introduction of each members in this
          project group.")
      )
    ),
    tabPanel(
      "Trend",
      tags$div(
        h3("The current sleeping time trend in U.S. population"),
        sidebarLayout(
          sidebarPanel(
            radioButtons("StudiesMethods",
              label = h3("Studies' Methods"),
              choices = list(
                "Actigraphic Study" = 1,
                "Polysomnography Study" = 2,
                "Both Studies" = 3
              ),
              selected = 3
            ),
            hr(),
          ),
          mainPanel(
            plotOutput("us_timeline")
          )
        ),
        p("This graph represents the average sleep time in minutes for adults
          (18-39) in the U.S from 2000 to 2015. The study methods include
          *Actigraphic Study and *Polysomnography Study."),
        p("For Actigraphic Study, the trend experiences a drastic decline from
          the year 2000 (the highest point) to 2002, then it turns to a small
          and steady decline until 2006. Starting from 2006, the trend grows
          constantly for three years then keeps decreasing to its lowest point
          at the end."),
        p("For Polysomnography Study, the trend remains steady from the
          beginning year, 2000, to 2006. It increases by little for half of a
          year then goes down constantly with small fluctuation. Starting from
          2009, when the trend reaches its lowest point, it goes upward slowly
          until the end."),
        tags$b("Note:"),
        p("* Actigraphic Study: Actigraphy is a non-invasive technique used to
          assess cycles of activity and rest over several days to several
          weeks."),
        p("(2019,
          Stanford Health Care.
          https://stanfordhealthcare.org/medical-tests/s/sleep-disorder-tests/procedures/actigraphy.html)"),
        p("* Polysomnography Study: A polysomnogram continuously records brain
          waves during sleep, as well as a number of nerve and muscle functions
          during nighttime sleep."),
        p("(2019, Stanford Health Care.
          https://stanfordhealthcare.org/medical-tests/p/polysomnogram.html)"),
        h3("Geographic map of US adults sleeping <7 hours"),
        plotOutput("us_map_7"),
        p("The geographic map illustrates the percentage of people in each
          state in the U.S that sleep less than 7 hours. As the percentage of
          people gets higher, the black color goes darker. As shown in the
          graph, states that have the largest population of having less than
          7 hours of sleep are mostly located in the Midwest. On the contrary,
          western states tend to have fewer people who do not get sufficient
          sleep."),
        p("This graph allows people to have a brief idea of a lack of sleep
          in each state at one glance. People can easily pick up the states
          which they want to have a closer look on sleeping issues accordingly
          to the information presented in the graph.")
      )
    ),
    navbarMenu(
      "Causes",
      tabPanel(
        "Multiple Factors",
        titlePanel("Why are we staying up so late?"),
        p("University students answered to a self-report of multiple causes of
          their sleep deprivation, which are categorized into the below pie
          chart: "),
        plotlyOutput("pie_chart"),
        p("The interactive pie chart demonstrates the most common factors that
          cause U.S college students stay up so late at night based on the
          survey. Although there are 14 categories presenting on this chart,
          it could be organized to 4."),
        p("The first one is Dorm/Sleeping environment’s poor quality, including
          tobacco smoke in sleeping room(7.97%), room’s bad air quality(6.89%),
          room scents(6.64%), and noise from next door (6.5%). The second
          category is student’s mental state and feelings, including stress
          (8.1%), fatigue (6.69%), sadness (6.64%), depression (7.97%), being
          patient (6.89)and finally, anxiety and tension (6.39%). The third
          category is student’s physical state, which are pain (7.87%) and
          strenuous physical activity (6.74%). The fourth category is family
          issue, making up 7.82 % of the pie chart. (The rest of the 6 percent
          is reported as other.)"),
        p("Overall, students’ poor sleeping/ resting environment makes up 28%
          of the pie chart while student’s mental state takes up to 42.6 %,
          almost half of the sleep deprived students is affected by their
          mental states. Physical state occupied 14.61 percent of the chart and
          family issue has least effect on student sleep, which is only 7.82
          percent. ")
      ),
      tabPanel(
        "Life Tracking Sample",
        titlePanel("Let's see what people in U.S. do during the day"),
        sidebarLayout(
          sidebarPanel(
            selectInput("select.activities",
              label = h4("Select an activity to compare with sleep's time:"),
              choices = list(
                "Cook" = "cook", "Eat" = "eat",
                "Math" = "math", "Music" = "music",
                "Pause" = "pause", "Prep" = "prep",
                "Uni" = "uni", "Meditation" = "meditation",
                "Special" = "special", "Work" = "work"
              ),
              selected = "cook"
            ),
            hr(),
          ),
          mainPanel(
            plotlyOutput("compared.bar")
          )
        ),
        h3("Let's see what people in U.S. do during the day:"),
        p("The interactive scatter plot compare different activity time with
          sleeping-time. The x-axis will be all kinds of different activities
          that can be chosen from the side bar. Y-axis will be the general
          sleep-time."),
        p("There are some interesting ups and downs for some graphs like
          “cook”, “eat”, “music”, and even “work”. We don’t know the causal or
          correlational factors of those bumps, which means further research
          need to be down with that."),
        p("But for math, it’s pretty clear that generally, if they do more math
          problems and use more of the brain, the less sleep people are getting.
          It can be an analog to doing homework as if in students’ life."),
        p("In general, all activities have a tendency to go down except for
          music and meditation. It seems that people have so many things to do
          in life, studying, social networking, hanging out with friends that
          they can not even have enough time to sleep.")
      )
    ),
    tabPanel(
      "Impact",
      titlePanel("Risks taken for shortened sleep"),
      sidebarLayout(
        sidebarPanel(
          radioButtons("age",
            label = h3("Age Groups"),
            choices = list(
              "Young" = "Young",
              "Old" = "Old"
            ),
            selected = "Young"
          ),
          hr(),
          radioButtons("symptoms",
            label = h4("Possible Symptoms"),
            choices = list(
              "Anxiety" = "anxiety",
              "Depression" = "depression",
              "Panic" = "panic",
              "Worry" = "worry",
              "Health Problems" = "health"
            ),
            selected = "anxiety"
          )
        ),
        mainPanel(
          plotOutput("sleep_impacts")
        )
      ),
      p("This interactive scatterplot allows user to choose their own interest
        of age group and multiple outcomes of sleep deprivation. The dataset is
        retrieved from kaggle where the gathered data about 90 patients in
        different age groups and measured their physical and psychological
        health. In our plot, we used 6 different factors: "),
      p("Age group including old (65 - 75 years old) and young (20 - 30 years
        old) people. "),
      p("Anxiety and depression rating is from the hospital anxiety and
        depression scale. "),
      p("Worry, panic, and health problems are from Karolinska Sleep
        Questionnaire. "),
      p("For the younger group of people, they have an average rating of
        anxiety for about 2.92. Whereas the older age group only have 1.49.
        And for panic and worry, the younger group is higher for about .5
        rating. For health problems, the younger group are worse by .7 rating
        for self-assessment. This contrast illustrates that there is a weird
        paradox in health problems. When young people are supposed to be strong
        and healthy, and older people are more prone to have health issues, the
        reality is in reverse."),
      p("The lack of sleep is strongly impacting people’s lives. With
        increasing anxiety and potential health problems. Because this lacking
        mostly influence mental functioning, and all human activities rely on
        those 3 pounds little brain, it’s crucial that people should pay more
        attention to sleeping issues and try to get rid of the malicious effect
        of not sleeping enough. "),
      h3("The relationship between sleep deprivation and student's GPA"),
      plotlyOutput("sleep_GPA"),
      p("This graph demonstrates U.S college students’ average GPA affected by
        daytime sleepiness. As shown above, students who report not feeling
        fatigued have a 3.24 GPA, which is 0.2 higher than sleepy students’
        3.04 GPA."),
      p("Academically, the lack of sleep could cause students trouble
        concentrating in class and performing their knowledge during exams. A
        lot of students sacrifice their sleep time and stay up late at night to
        study for exams or do assignments. However, this does not have positive
        long-term impacts on their academics. Not getting enough sleep at night
        results in a much lower GPA than students who get at least 7 hours of
        sleep. While working hard on schoolwork, students should always remember
        sleep is the biggest priority.")
    ),
    tabPanel(
      "Conclusion",
      tags$div(
        h3("Conclusion"),
        p("The strength of our project is that our resources for datasets are
          from authentic organizations, including American Academy of Sleep
          Medicine (AASM), National Alliance on Mental Illness (NAMI), and the
          Centers for Disease Control and Prevention (CDC). By using these
          credible sources, our group ensures that the information presented
          in our project is reliable. On the other hand, one of the weaknesses
          of our project is the narrow age range we covered. We only targeted
          people aged from 18 to 39, which makes up about 26.3 percent of the
          U.S population. he project could be more applicable to more users.
          The main lesson our team learned from this project is, the sleeping
          trend in the U.S in recent years is getting worse. We found out that
          the lack of sleep could affect not only students' academic
          performance but also human health. In the future, people could
          improve the project by extending the age group and provide
          suggestions to improve people’s sleeping time and sleeping quality.
          Our team would also like to look deeper into the sleeping trend in
          different countries other than the U.S to make a comparison, as well
          as how foreign governments approach sleeping issues.")
      ),
      tags$hr(),
      tags$div(
        h3("Suggested sleep-time according to your age:"),
        h5("The sleep time calculator allows the user to choose their age and
           the time they plan to wake up. Then, the calculator will suggest the
           time user should go to bed based on the information given."),
      ),
      sidebarLayout(
        sidebarPanel(
          h4("Sleep-time calculation"),
          sliderInput("age_years", "How old are you?",
            min = 1, max = 99,
            value = 19
          ),
          sliderInput("awake_time", "What time do you need to wake up?",
            min = 0, max = 23,
            value = 8
          )
        ),
        mainPanel(
          textOutput("years_old"),
          textOutput("awake"),
          textOutput("sleep_time")
        )
      )
    ),
    navbarMenu(
      "About",
      tabPanel(
        "About Tech",
        titlePanel("Give credit to all the amazing sources!"),
        tags$div(
          p("[1] Cunningham, J. (2019). College students aren’t getting nearly enough sleep. Retrieved from http://sleepeducation.org/news/2019/07/18/college-students-are-not-getting-nearly-enough-sleep"),
          p("[2] Feraco, F. (2018). Sleep Deprivation. Retrieved from https://www.kaggle.com/feraco/sleep-deprivation#demdata_160225_pseudonymized.csv"),
          p("[3] Fusion 360. (2014). Sleepless Nights. Retrieved from https://visual.ly/community/infographic/health/sleepless-nights"),
          p("[4] Healthguru. (2012). Need More Sleep? The Facts On Sleeping Disorders. Retrieved from https://visual.ly/community/infographic/health/need-more-sleep-facts-sleeping-disorders"),
          p("[5] Lomuscio, M. (2019). Sleep Study. Retrieved from https://www.kaggle.com/mlomuscio/sleepstudypilot"),
          p("[6] Mental Health Guide for College Students. (2019). Retrieved from https://collegestats.org/resources/mental-health-guide/"),
          p("[7] Youngstedt, Shawn D et al. “Has adult sleep duration declined over the last 50+ years?.” Sleep medicine reviews vol. 28 (2016): 69-85. doi:10.1016/j.smrv.2015.08.004"),
          p("[8] “500 Cities: Local Data for Better Health, 2018 Release.” Centers for Disease Control and Prevention, Centers for Disease Control and Prevention, https://chronicdata.cdc.gov/500-Cities/500-Cities-Local-Data-for-Better-Health-2018-relea/6vp6-wxuq"),
          p("[9] Monideepa B. Becerra, Brittny S. Bol, Rochelle Granados & Christina Hassija (2018) Sleepless in school: The role of social determinants of sleep health among college students, Journal of American College Health, DOI: 10.1080/07448481.2018.1538148"),
          p("[10] Life tracking project dataset. Retrieved from: https://www.kaggle.com/maxschmidt94/life-tracking-project-dataset#life_total_data.csv"),
          p("[11] 2019 American Academy of Sleep Medicine. (n.d.). Make Time 2 Sleep. Retrieved December 4, 2019, from http://sleepeducation.org/healthysleep/Make-Time-2-Sleep-Bedtime-Calculator?fbclid=IwAR0YjgcVl6BzJW1CFOCoVq0s3niDqMt5Ju5NOzePy6Nm1OBt2halh21spGs."),
          p("[12] Altun, I., Cınar, N., & Dede, C. (2012). The contributing factors to poor sleep experiences in according to the university students: A cross-sectional study. Journal of research in medical sciences : the official journal of Isfahan University of Medical Sciences, 17(6), 557–561."),
          h5("And a special thanks to Andrey Butenko, our wonderful TA who
             helped us a lot through this course and on this project :) ")
        )
      ),
      tabPanel(
        "About Us",
        titlePanel("More Information on project members!"),
        fluidRow(
          column(
            8,
            h3("Phuong Vu"),
            p("Phuong Vu is an international student at the University of
              Washington who wants to study Informatics, and this is his second
              year at the UW. He enjoys writing code that would solve real-life
              tasks. During his free time, he loves traveling to new places to
              take artistic photos and creating videos.")
          ),
          column(4, imageOutput("pvu", height = 200))
        ),
        hr(),
        fluidRow(
          column(
            8,
            h3("Yu-Wen Chen"),
            p("Yu-Wen Chen is currently a Freshman at the University of
              Washington from Taoyuan, Taiwan. She enjoys creative problem
              solving and figuring things out with her team. Outside of  the
              classroom, she loves spending time doing creative writing and
              reading Asian literature. Most importantly, she thinks her dog
              May-May is the cutest dog in the universe."),
          ),
          column(4, imageOutput("ychen", height = 200))
        ),
        hr(),
        fluidRow(
          column(
            8,
            h3("Hanzhi Cao"),
            p("Hanzhi Cao is an international student at the UW studying
              Psychology in her senior year. On one hand she loves psychology
              and would love to know more about the mysterious human kind.
              On the other hand, she is also into data field that people are
              generating data every day every second. She believes that
              efficiency is EVERYTHING, so her ultimate goal of life is to find
              a better way to improve human life experience."),
          ),
          column(4, imageOutput("hcao", height = 200))
        ),
        hr(),
        fluidRow(
          column(
            8,
            h3("Vivian Law"),
            p("Vivian Law is a junior student at the University of Washington.
              She is in the Early Childhood Family Studies major. She enjoys
              photography and trying different foods. She has a passion for
              children and for technology. She values her Taiwanese and
              Cantonese culture.")
          ),
          column(4, imageOutput("vlaw", height = 200))
        )
      )
    )
  )
)
